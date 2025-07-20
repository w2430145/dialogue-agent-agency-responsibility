# -----------------------------------------------------------------------------
# Required Functions Source (assuming script files are in the same directory)
# -----------------------------------------------------------------------------
# These R scripts implement Bayesian rank-based hypothesis tests, specifically
# for Spearman's rho correlation, based on the methodology described in:
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
source('spearmanSampler.R')         # Contains spearmanGibbsSampler function

# -----------------------------------------------------------------------------
# Experimental Data (defined as R vectors)
# -----------------------------------------------------------------------------
aa_responsibility <- c(3, 4, 3, 1, 1, 3, 3, 3, 5, 3, 2, 5, 6, 2, 5, 5, 2, 1, 5, 2, 2, 2)
experience_diff <- c(1.7, 0, 1.6, 0.3, 0.7, 1.2, -0.1, -0.9, -0.1, -0.3, -0.5, 0.1, 1, 2.3, 0, 0.7, 0.6, 0.1, 0.7, -0.1, -0.5, -0.5)

n <- length(aa_responsibility)
if (n != length(experience_diff)) {
  stop("Input arrays must have the same length.")
}
print(paste("Sample size (N):", n))

# -----------------------------------------------------------------------------
# Calculating Bayes Factor for Spearman's Rho
# -----------------------------------------------------------------------------

# Generate samples from the posterior distribution of rho using spearmanGibbsSampler.
# nSamples: Number of samples to draw (more samples generally lead to better stability but take more time).
# progBar: Whether to display a progress bar during sampling.
# nBurnin: Number of burn-in samples to discard (initial unstable samples).
# nChains: Number of independent Markov chains to run (useful for convergence diagnostics).
# kappaPriorParameter: Parameter for the prior distribution (default is 1.0, as recommended in the paper).
#                      This parameter controls the spread of the prior distribution for rho.
#                      (The default a=b=1 corresponds to a uniform prior on rho).
#                      For Spearman's rho, the priorParameter is kappa (the inverse scale of the Beta distribution).
#                      The example in ExampleAnalyses.R for Spearman's rho uses the default value of 1.
rhoSamples <- spearmanGibbsSampler(xVals = aa_responsibility,
                                   yVals = experience_diff,
                                   nSamples = 1e4, # 10,000 samples for convergence and stability
                                   progBar = TRUE,
                                   nBurnin = 2e3,  # Set a larger burn-in period
                                   nChains = 4,    # Run multiple chains
                                   kappaPriorParameter = 1) # Default value

# Display a histogram of the posterior distribution (Optional: Uncomment to enable)
# This helps in visualizing the results.
# hist(rhoSamples$rhoSamples, main = "Posterior Distribution of Spearman's Rho",
#      xlab = "Spearman's Rho", freq = FALSE)

# Compute the Bayes Factor BF10
# Using the computeBayesFactorOneZero function.
# posteriorSamples: Posterior samples of rho obtained from spearmanGibbsSampler.
# whichTest: Specifies "Spearman" for the test type.
# priorParameter: The same value used in the Gibbs sampler (default is 1).
# oneSided: Specify "right" or "left" for a one-sided test. FALSE for a two-sided test (default).
bf10_spearman_exact <- computeBayesFactorOneZero(posteriorSamples = rhoSamples$rhoSamples,
                                                 whichTest = "Spearman",
                                                 priorParameter = 1, # Same value as in Gibbs sampler
                                                 oneSided = FALSE) # Two-sided test in this case

print(paste("Bayes Factor (BF10, exact model) for Spearman correlation:", round(bf10_spearman_exact, 3)))

# -----------------------------------------------------------------------------
# Interpretation of Results (Optional: Uncomment to enable)
# -----------------------------------------------------------------------------
# The interpretation of the Bayes Factor is based on the following criteria:
# if (bf10_spearman_exact > 100) {
#   interpretation <- "The hypothesis of a correlation (H1) is supported by extreme evidence."
# } else if (bf10_spearman_exact > 30) {
#   interpretation <- "The hypothesis of a correlation (H1) is supported by very strong evidence."
# } else if (bf10_spearman_exact > 10) {
#   interpretation <- "The hypothesis of a correlation (H1) is supported by strong evidence."
# } else if (bf10_spearman_exact > 3) {
#   interpretation <- "The hypothesis of a correlation (H1) is supported by moderate evidence."
# } else if (bf10_spearman_exact > 1) {
#   interpretation <- "The hypothesis of a correlation (H1) is supported by anecdotal evidence."
# } else if (bf10_spearman_exact == 1) {
#   interpretation <- "The data equally support both hypotheses (no evidence)."
# } else if (bf10_spearman_exact < 1/100) { # BF01 > 100
#   interpretation <- "The hypothesis of no correlation (H0) is supported by extreme evidence."
# } else if (bf10_spearman_exact < 1/30) { # BF01 > 30
#   interpretation <- "The hypothesis of no correlation (H0) is supported by very strong evidence."
# } else if (bf10_spearman_exact < 1/10) { # BF01 > 10
#   interpretation <- "The hypothesis of no correlation (H0) is supported by strong evidence."
# } else if (bf10_spearman_exact < 1/3) { # BF01 > 3
#   interpretation <- "The hypothesis of no correlation (H0) is supported by moderate evidence."
# } else { # BF01 < 3
#   interpretation <- "The hypothesis of no correlation (H0) is supported by anecdotal evidence."
# }
#
# print(paste("Interpretation:", interpretation))

# -----------------------------------------------------------------------------
# Convergence Diagnostics (Optional: Uncomment to enable)
# -----------------------------------------------------------------------------
# Check if the MCMC sampling has converged well. An R-hat value close to 1.0 is good.
# Typically, values below 1.01 or 1.05 are considered acceptable.
# print(paste("R-hat (Gelman-Rubin statistic):", round(rhoSamples$rHat, 3)))
# if (rhoSamples$rHat > 1.05) {
#   warning("R-hat value is high. Consider increasing nSamples or nChains for better convergence.")
# }