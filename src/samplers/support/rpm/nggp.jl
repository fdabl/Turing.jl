########################################
# Normalised Generalized Gamma Process #
########################################

immutable T_NGGP <: TotalMassDistribution
    sigma         ::  Float64
    tau           ::  Float64
end

Distributions.rand(d::T_NGGP) = rand(ExpTiltedSigma(d.sigma, d.tau))
Distributions.logpdf{T<:Real}(d::T_NGGP, x::T) = 0

immutable SBS_NGGP <: SizeBiasedSamplingDistribution
    u_sigma       ::  Float64 # sigma = u_sigma/v_sigma
    v_sigma       ::  Float64 # u and v coprimes
    T_surplus     ::  Float64
end

Distributions.rand(d::SBS_NGGP) = begin
  lambda = u_sigma^2 / v_sigma^(v_sigma/u_sigma)
  Y = rand(InverseGamma(1 - u_sigma/v_sigma, lambda))
  inv_X = rand(exp_tiltedrand(u_sigma, v_sigma, lambda))
  X = 1/inv_X
  d.T_surplus * X / (X + Y)
end

Distributions.logpdf{T<:Real}(d::SBS_NGGP, x::T) = 0