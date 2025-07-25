# -----------------------------------------------------------------------------
# Required functions source (assuming script files are in the same directory)
# -----------------------------------------------------------------------------
# These R scripts implement Bayesian rank-based hypothesis tests, specifically
# the Wilcoxon Signed-Rank Test and related common functions,
# based on the methodology described in:
#
# van Doorn, J., Ly, A., Marsman, M., & Wagenmakers, E.-J. (2020).
# Bayesian rank-based hypothesis testing for the rank sum test,
# the signed rank test, and Spearman's ρ.
# Journal of Applied Statistics, 47(16), 2984-3006.
# https://doi.org/10.1080/02664763.2019.1709053
#
# If you need to run this code and require the source scripts (e.g.,
# 'rankBasedCommonFunctions.R', 'signRankSampler.R', 'spearmanSampler.R',
# 'rankSumSampler.R'), please refer to the supplementary materials
# provided with the original publication or contact the authors.
#
source('rankBasedCommonFunctions.R') # Contains computeBayesFactorOneZero function
source('signRankSampler.R')         # Contains signRankGibbsSampler function

# -----------------------------------------------------------------------------
# Experimental Data (defined as R vectors)
# This data might originate from a Python script or analysis.
# -----------------------------------------------------------------------------
sota_likability_pre <- c(4, 4.8, 4.6, 4.4, 3.8, 3.8, 3.6, 3.6, 4.2, 4.6, 3.4, 3.4, 2.6, 3.8, 3.2, 4.4, 4.6, 2.8, 3.2, 3.4, 5, 3.6)
sota_likability_post <- c(4.6, 4.8, 4.8, 4.8, 2.6, 2.6, 3.8, 4.2, 3.2, 4.8, 3.6, 3.8, 3.6, 5, 4.4, 4.6, 4.8, 3.6, 3.4, 4, 4.4, 4.6)

n_samples <- length(sota_likability_pre)
if (n_samples != length(sota_likability_post)) {
  stop("Input arrays must have the same length.")
}
print(paste("Sample size (N):", n_samples))

# -----------------------------------------------------------------------------
# Performing Bayesian Wilcoxon Signed Rank Test
# -----------------------------------------------------------------------------
# Using the signRankGibbsSampler function to obtain posterior samples of delta
# (effect size for the median of differences).
# The 'cauchyPriorParameter' defines the scale of the Cauchy prior on delta,
# influencing the prior belief about the magnitude of the effect.
# 'nSamples' sets the number of posterior samples to generate.
# 'testValue' specifies the null hypothesis value for the median difference.
# 'nChains' indicates the number of independent MCMC chains.
# 'nBurnin' specifies the number of burn-in samples to discard from each chain.
# 'nGibbsIterations' refers to iterations within the Gibbs sampler for convergence.
posteriorSamples <- signRankGibbsSampler(
  xVals = sota_likability_pre,
  yVals = sota_likability_post,
  nSamples = 1e4,
  cauchyPriorParameter = 1/sqrt(2),
  testValue = 0,
  nBurnin = 1e3,
  nGibbsIterations = 10,
  nChains = 10
)

# -----------------------------------------------------------------------------
# Computing Bayes Factor
# -----------------------------------------------------------------------------
# The computeBayesFactorOneZero function calculates the Bayes Factor (BF10)
# comparing the alternative hypothesis (H1) against the null hypothesis (H0).
# BF10 > 1 indicates evidence for H1; BF10 < 1 indicates evidence for H0.
# The 'posteriorSamples' are the MCMC samples of delta obtained from the Gibbs sampler.
# 'priorParameter' corresponds to the scale parameter of the Cauchy prior used for delta.
# The null hypothesis is inherently assumed to be at 0 within this function's design.
BF10_sota_likability <- computeBayesFactorOneZero(
  posteriorSamples = posteriorSamples,
  priorParameter = 1/sqrt(2)
)

print(paste("Bayes Factor (BF10) for sota_likability:", BF10_sota_likability))

# -----------------------------------------------------------------------------
# Interpretation of Results (Optional: Uncomment to enable)
# -----------------------------------------------------------------------------
# The interpretation of the Bayes Factor is based on the following criteria:
# if (BF10_sota_likability > 100) {
#   interpretation <- "H1 (a difference exists) is supported by extreme evidence."
# } else if (BF10_sota_likability > 30) {
#   interpretation <- "H1 (a difference exists) is supported by very strong evidence."
# } else if (BF10_sota_likability > 10) {
#   interpretation <- "H1 (a difference exists) is supported by strong evidence."
# } else if (BF10_sota_likability > 3) {
#   interpretation <- "H1 (a difference exists) is supported by moderate evidence."
# } else if (BF10_sota_likability > 1) {
#   interpretation <- "H1 (a difference exists) is supported by anecdotal evidence."
# } else if (BF10_sota_likability == 1) {
#   interpretation <- "The data equally support both hypotheses (no evidence)."
# } else if (BF10_sota_likability < 1/100) { # BF01 > 100
#   interpretation <- "H0 (no difference exists) is supported by extreme evidence."
# } else if (BF10_sota_likability < 1/30) { # BF01 > 30
#   interpretation <- "H0 (no difference exists) is supported by very strong evidence."
# } else if (BF10_sota_likability < 1/10) { # BF01 > 10
#   interpretation <- "H0 (no difference exists) is supported by strong evidence."
# } else if (BF10_sota_likability < 1/3) { # BF01 > 3
#   interpretation <- "H0 (no difference exists) is supported by moderate evidence."
# } else { # BF01 < 3
#   interpretation <- "H0 (no difference exists) is supported by anecdotal evidence."
# }
#
# print(paste("Interpretation:", interpretation))

# -----------------------------------------------------------------------------
# Visualization of Posterior Distribution (Optional: Uncomment to enable)
# -----------------------------------------------------------------------------
# This section generates a histogram of the posterior samples of delta,
# allowing for visual inspection of the estimated effect size distribution.
#
# hist(posteriorSamples, breaks = 50, main = "Posterior Distribution of Delta",
#      xlab = "Delta (Effect Size)", ylab = "Density", freq = FALSE)
# lines(density(posteriorSamples), col = "blue", lwd = 2) # Add density curve
# abline(v = 0, col = "red", lty = 2) # Add line at null hypothesis (delta = 0)