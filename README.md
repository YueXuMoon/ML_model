# Netflix User Churn Prediction: Random Forest vs Gradient Boosting

[![Quarto](https://img.shields.io/badge/Made%20with-Quarto-blue.svg)](https://quarto.org)
[![Python](https://img.shields.io/badge/Python-3.11+-green.svg)](https://www.python.org/)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/YOUR_USERNAME/YOUR_REPO/main?filepath=project/random_forest.ipynb)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 🚀 **Click the Binder badge above to run this notebook interactively in your browser!** (Replace YOUR_USERNAME/YOUR_REPO with your GitHub info)

## Project Overview

This project analyzes Netflix user behavior data (210K+ records) to predict user churn using ensemble machine learning methods. We compare **Random Forest** and **Gradient Boosting** algorithms with various hyperparameter configurations.

### Key Results
- ✅ **>95% accuracy** achieved by both models
- ✅ **Gradient Boosting (depth=2, lr=0.1)**: 3.5% test error
- ✅ **Random Forest (m=√p)**: 3.8% test error, more stable
- ✅ **Top predictors**: engagement metrics, watch time, recommendation interactions

## 📊 View & Run Online

### 🔴 Run Interactive Notebook (Code Execution)
- **[Launch in Binder](https://mybinder.org/v2/gh/YOUR_USERNAME/YOUR_REPO/main?filepath=project/random_forest.ipynb)** - Run and modify code in browser (no installation needed)

### 📄 View Static HTML (Read Only)
- **[Full Analysis HTML](random_forest.html)** - Complete notebook with all visualizations
- **[Presentation Slides](random_forest_slides.html)** - 6-slide executive summary

> 💡 **To view HTML on GitHub**: After pushing to your repository, use:
> `https://htmlpreview.github.io/?https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/project/random_forest.html`

## 📂 Repository Structure

```
project/
├── random_forest.ipynb          # Main analysis notebook (source)
├── random_forest.html           # 🌐 GitHub-viewable HTML version
├── random_forest_report.qmd     # Quarto HTML report (source)
├── random_forest_slides.qmd     # Quarto presentation (source)
├── random_forest_slides.html    # 🌐 Presentation HTML
├── custom.scss                  # Netflix-themed styling
├── README.md                    # This file
└── archive/                     # Data files
    ├── users.csv
    ├── movies.csv
    ├── watch_history.csv
    ├── recommendation_logs.csv
    ├── search_logs.csv
    └── reviews.csv
```

## 🚀 Getting Started

### Prerequisites

```bash
# Install Python dependencies
pip install pandas numpy matplotlib seaborn scikit-learn jupyter

# Install Quarto
# macOS
brew install quarto

# Or download from: https://quarto.org/docs/get-started/
```

### Running the Analysis

1. **Jupyter Notebook:**
```bash
jupyter notebook random_forest.ipynb
```

2. **Generate HTML Report:**
```bash
quarto render random_forest_report.qmd
```

3. **Generate Presentation:**
```bash
quarto render random_forest_slides.qmd
```

### Viewing on GitHub

The Quarto HTML report is self-contained and can be viewed directly on GitHub Pages:

1. Go to repository Settings → Pages
2. Set source to "main" branch
3. Access at: `https://[username].github.io/[repo-name]/random_forest_report.html`

Or view the slides at: `https://[username].github.io/[repo-name]/random_forest_slides.html`

## 📊 Analysis Components

### 1. Data Exploration
- 210,000+ user records
- 30 engineered features
- Binary classification (active/inactive)
- 80/20 train-test split

### 2. Random Forest Analysis
- **3 configurations**: m=√p, m=p/2, m=p
- **500 trees** each
- Feature importance via Gini reduction
- Convergence analysis

### 3. Gradient Boosting Analysis
- **3 depths**: 1, 2, 5
- **3 learning rates**: 0.01, 0.05, 0.1
- Sequential error correction
- Hyperparameter tuning

### 4. Model Comparison
- Test error vs number of trees
- Convergence speed analysis
- Performance metrics comparison
- Business recommendations

## 📈 Key Findings

### Model Performance

| Model | Configuration | Test Error | AUC | Notes |
|-------|--------------|------------|-----|-------|
| **GB** | depth=2, lr=0.1 | **3.5%** | 0.965 | Best accuracy |
| **RF** | m=√p | **3.8%** | 0.962 | Most stable |
| GB | depth=1, lr=0.05 | 4.2% | 0.960 | Good balance |
| RF | m=p/2 | 4.0% | 0.961 | Moderate |

### Top Churn Predictors
1. 📺 Total watch minutes
2. 🔄 Session count
3. 👆 Recommendations clicked
4. 💰 Monthly spend
5. ✅ Completion rate

## 🎯 Business Applications

### High-Risk User Indicators
- Declining watch time week-over-week
- Reduced session frequency
- Lower recommendation click-through rate
- Decreased content completion rate

### Intervention Strategies
- **Tier 1** (>70% risk): Personalized campaigns, exclusive content
- **Tier 2** (40-70% risk): Enhanced recommendations, viewing reminders
- **Tier 3** (<40% risk): Maintenance monitoring

### ROI Estimation
- **Intervention cost**: $5 per user
- **Expected value**: $45 per successful intervention
- **Break-even**: 2.5% success rate

## 📄 Reports

### HTML Report (`random_forest_report.qmd`)
Comprehensive analysis including:
- Full methodology
- Detailed results
- Performance comparisons
- Business recommendations
- Technical appendix

### Presentation (`random_forest_slides.qmd`)
6-slide deck covering:
1. Project Overview
2. Random Forest Results
3. Gradient Boosting Results
4. Model Comparison
5. Business Impact
6. Conclusions & Recommendations

## 🛠️ Technical Details

### Hyperparameters

**Random Forest:**
```python
RandomForestClassifier(
    n_estimators=500,
    max_features={√p, p/2, p},
    random_state=42,
    n_jobs=-1
)
```

**Gradient Boosting:**
```python
GradientBoostingClassifier(
    n_estimators=500,
    max_depth={1, 2, 5},
    learning_rate={0.01, 0.05, 0.1},
    subsample=0.8,
    random_state=42
)
```

## 📚 References

1. Breiman, L. (2001). "Random Forests". Machine Learning, 45(1), 5-32.
2. Friedman, J. H. (2001). "Greedy function approximation: A gradient boosting machine". Annals of Statistics.
3. Hastie, T., et al. (2009). "The Elements of Statistical Learning". Springer.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions or feedback, please open an issue in this repository.

---

**Last Updated**: November 30, 2025  
**Dataset**: Netflix 2025 User Behavior (210K+ records)  
**Methods**: Random Forest, Gradient Boosting, Ensemble Learning
