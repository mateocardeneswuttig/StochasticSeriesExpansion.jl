

@testset "VertexData" begin
    @test S.isinvalid(S.Transition())

    @testset "vertex_change_apply" begin
        dim = 4
        nsites = 2
        leg_states =
            reduce(hcat, collect.(Iterators.product(fill(UInt8.(1:dim), 2 * nsites)...)))

        for step_in in Iterators.product(1:2*nsites, 1:S.worm_count(dim))
            v = rand(1:dim^(2*nsites))
            @test S.vertex_apply_change(
                leg_states,
                Tuple(dim for i = 1:2*nsites),
                v,
                step_in,
                (step_in[1], S.worm_inverse(step_in[2], dim)),
            ) == v
        end
    end

    @testset "S=1/2 Heisenberg" begin
        (splus, sz) = S.spin_operators(2)
        Hbond = kron(sz, sz) + 0.5 * (kron(splus, splus') + kron(splus', splus))

        vd = S.VertexData((2, 2), Hbond; energy_offset_factor = 0.0)

        @test vd.energy_offset ≈ -0.25
        @test sum(S.isinvalid.(vd.diagonal_vertices)) == 2
        @test all(vd.weights .≈ 0.5)
        @test vd.transition_cumprobs ≈ ones(4 * 4)

        for vertex = 1:length(vd.weights)
            for leg = 1:4
                @test vd.transition_step_outs[vd.transitions[leg, 1, vertex].offset][1] ==
                      xor(leg - 1, 1) + 1
            end
        end
    end

    @testset "Random Hamiltonian" begin
        dimss = [(4, 4), (2, 4)]

        for dims in dimss
            @testset "dims = $(dims)" begin
                Hbond = rand(prod(dims), prod(dims))

                vd = S.VertexData(dims, Hbond)
                for t in vd.transitions
                    @test S.isinvalid(t) || vd.transition_cumprobs[t.offset+t.length] ≈ 1.0
                end
            end
        end
    end
end