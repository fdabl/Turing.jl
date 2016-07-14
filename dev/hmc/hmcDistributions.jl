function hmcpdf(pdf::Function, x)
  return pdf(x)
end

###############################
# Distributions over integers #
###############################

function hmcBinomial(f, N)
  return r::Int64 -> factorial(N) / (factorial(r) * factorial(N - r)) * f^r * (1 - f)^(N - r)
end

# function hmcCategorical(k)
#   function pdf(x)
#     1 / k
#   end
#   return pdf
# end

function hmcPoisson(λ)
  return r::Int64 -> exp(-λ) * λ^r / factorial(r)
end

function hmcExponentialInt(f)
  return r::Int64 -> (1 - f) * exp(-ln(1 / f) * r)
end

#############################################
# Distributions over unbounded real numbers #
#############################################

function hmcNormal(μ, σ)
  return x::Dual -> 1 / sqrt((2pi)^2 * σ^2) * exp(-0.5 * (x - μ)^2 / σ^2)
end

# function hmcMvNormal(μ, Σ)
#   Λ = inv(Σ)
#   return x -> 1 / sqrt((2pi)^2 * det(Σ)) * exp(-0.5 * ((x - μ)' * Λ * (x - μ))[1])
# end

function hmcStudentT(μ, s, n)
  Z = sqrt(pi * n * s^2) * gamma(n / 2) / gamma((n + 1) / 2)
  return x::Real -> 1 / Z * 1 / (1 + (x - μ)^2 / (n * s^2))^((n + 1) / 2)
end

function hmcBiexponential(μ, s)
  return x::Real -> 1 / 2s * exp(-abs(x - μ) / s)
end

function hmcInverseCosh(β)
  return x::Real -> 1 / cosh(β * x)^(1 / β)
end

############################################
# Distributions over positive real numbers #
############################################

function hmcExponential(s)
  return x -> 1 / s * exp(-x / s)
end

function hmcGamma(s, c)
  return x -> 1 / (gamma(c) * s) * (x / s)^(c - 1) * exp(-x / s)
end

function hmcInverseGamma(s, c)
  return v -> 1 / (gamma(c) / s) * (1 / (s * v))^(c + 1) * exp(-1 / (s * v))
end

function hmcLogNormal(m, s)
  Z = sqrt(2pi * s^2)
  return x -> 1 / x * 1 / Z * exp(-(ln(x) - ln(m))^2 / (2 * s^2))
end

#########################################
# Distributions over periodic variables #
#########################################

function hmcVonMises(μ, β)
  return Θ -> 1 / (2pi * besselj0(β)) * exp(β * cos(Θ - μ))
end

####################################
# Distributions over probabilities #
####################################

function hmcBeta(u1, u2)
  Z = gamma(u1) * gamma(u2) / (gamma(u1 + u2))
  return p -> 1 / Z * p^(u1 - 1) * (1 - p)^(u2 - 1)
end

function hmcDirichelet(u...)
  Z = sum(map(gamma, u)) / gamma(sum(u))
  function pdf(p...)
    1 / Z * prod(p .^ (u - 1)) * (sum(p) == 1)
  end
  return pdf
end

# TODO: test my density functions
