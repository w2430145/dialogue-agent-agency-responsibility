## Repository Contents

This repository is structured into the following directories and files:

### `R_scripts/` (R Scripts)

This directory contains R scripts used for calculating Bayes Factors. These scripts were employed for Bayesian statistical hypothesis testing, specifically for rank-based tests such as the Wilcoxon Signed-Rank Test and Spearman's ρ correlation.

**Important Note:**

Some of the functions used within these R scripts, particularly the main samplers and helper functions for Bayes Factor calculation, are based on the methodology described in the following publication:

van Doorn, J., Ly, A., Marsman, M., & Wagenmakers, E.-J. (2020).
Bayesian rank-based hypothesis testing for the rank sum test,
the signed rank test, and Spearman's ρ.
*Journal of Applied Statistics, 47*(16), 2984-3006.
[https://doi.org/10.1080/02664763.2019.1709053]
To successfully run the code in this repository, you will need to separately obtain the R scripts provided with the original paper (e.g., `rankBasedCommonFunctions.R`, `signRankSampler.R`, `spearmanSampler.R`, `rankSumSampler.R`) and place them in the same directory as the R scripts in this repository. 

Included R scripts:
- `sota_likability.r`: Bayesian Wilcoxon Signed-Rank Test for pre-post difference in likability towards Sota.
- `spearman_agency_sota_responsibility.r`: Bayesian test of Spearman's correlation coefficient between agency attribution to Sota and responsibility attribution.
- `spearman_experience_aa_responsibility.r`: Bayesian test of Spearman's correlation coefficient between experience attribution to Sota and responsibility attribution to the agent adopter.
- `spearman_experience_sota_responsibility.r`: Bayesian test of Spearman's correlation coefficient between experience attribution to Sota and responsibility attribution to Sota.

### `Python_scripts/` (Python Scripts)

This directory contains Python scripts used for other data analyses.
- `the_effect_of_users__attribution_of_agency_toward_dialogue_agents_on_responsibility_attribution_to_agent_adopters_analysis.py`: Includes frequentist statistical tests such as the non-correlation test for Spearman's correlation coefficient and Wilcoxon Signed-Rank Test.

### `Experimental_Materials/` (Experimental Materials)

This directory contains materials used in the experiment.
- `Experimental Materials.docx`: instructions provided to participants, and questionnaire items in Japanese.

### `Raw_Data/` (Raw Data)

This directory contains the raw experimental results in CSV format.
- `TypeA_Pre.csv`: Responses collected before the task for utterance Type A.
- `TypeA_Post.csv`: Responses collected after the task for utterance Type A.
- `TypeB_Pre.csv`: Responses collected before the task for utterance Type B.
- `TypeB_Post.csv`: Responses collected after the task for utterance Type B.


## Contact

If you have any questions or require further clarification, please feel free to contact Eiichiro Watanabe at [w2430145@gl.cc.uec.ac.jp].

