function make_operator(func, magnet::S.Models.Magnet)
    dims = [site.spin_states for site in magnet.site_params]

    lifter = Lifter(dims)
    op = spzeros(prod(dims), prod(dims))
    op = func(op, lifter)
    return op
end

function hamiltonian(magnet::S.Models.Magnet)
    return make_operator(magnet) do H, lifter
        for (bond, params) in zip(magnet.lattice.bonds, magnet.bond_params)
            H +=
                params.J * heisen_bond(lifter, bond.i, bond.j) +
                params.d * spin(lifter, bond.i, 3) * spin(lifter, bond.j, 3) +
                params.hz * (spin(lifter, bond.i, 3) + spin(lifter, bond.j, 3))
            +params.Dx * (spin(lifter, bond.i, 1)^2 + spin(lifter, bond.j, 1)^2) +
            params.Dz * (spin(lifter, bond.i, 1)^2 + spin(lifter, bond.j, 3)^2)
        end
        return H
    end
end


function calc_magnetization!(
    obs::AbstractDict{Symbol,<:Any},
    magnet::S.Models.Magnet,
    ens::Ensemble;
    ordering_vector::Tuple,
    stagger_uc::Bool,
    prefix::AbstractString,
)

    M =
        make_operator(magnet) do M, lifter
            for i in eachindex(magnet.site_params)
                M +=
                    S.staggered_sign(magnet.lattice, ordering_vector, stagger_uc, i) *
                    spin(lifter, i, 3)
            end
            return M
        end ./ S.normalization_site_count(magnet)

    obs[Symbol(prefix * "Mag")] = mean(ens, M)
    m2 = mean(ens, M^2)
    m4 = mean(ens, M^4)
    obs[Symbol(prefix * "Mag2")] = m2
    obs[Symbol(prefix * "Mag4")] = m4
    obs[Symbol(prefix * "AbsMag")] = mean(ens, abs.(M))

    obs[Symbol(prefix * "BinderRatio")] = m2 .^ 2 ./ m4
end

function calc_observables!(
    obs::AbstractDict{Symbol,<:Any},
    magnet::S.Models.Magnet,
    ens::Ensemble,
)
    for stagger_uc in (false, true)
        for q in Iterators.product(((false, true) for _ = 1:S.dimension(magnet.lattice))...)
            calc_magnetization!(
                obs,
                magnet,
                ens;
                ordering_vector = q,
                stagger_uc = stagger_uc,
                prefix = String(S.magest_standard_prefix(q, stagger_uc)),
            )
        end
    end
end
