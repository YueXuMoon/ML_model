# Quick Start Guide: Generating Quarto HTML & Slides

## 📋 What Was Created

I've created 4 new files for you:

1. **`random_forest_report.qmd`** - Full HTML report (comprehensive analysis)
2. **`random_forest_slides.qmd`** - 6-slide presentation 
3. **`custom.scss`** - Netflix-themed styling (red/black color scheme)
4. **`README.md`** - GitHub repository documentation
5. **`render_quarto.sh`** - Automated rendering script

## 🚀 Quick Start (3 Steps)

### Step 1: Install Quarto (if not already installed)

**macOS:**
```bash
brew install quarto
```

**Windows/Linux:** Download from https://quarto.org/docs/get-started/

### Step 2: Render HTML & Slides

**Option A - Use the automated script:**
```bash
cd /Users/yuexu/Documents/5052/hw/project
./render_quarto.sh
```

**Option B - Manual commands:**
```bash
# Generate HTML report
quarto render random_forest_report.qmd

# Generate presentation slides
quarto render random_forest_slides.qmd
```

### Step 3: View the outputs

```bash
# Open in browser (macOS)
open random_forest_report.html
open random_forest_slides.html
```

## 📊 What's Included

### HTML Report (`random_forest_report.qmd`)
✅ Complete 10-section analysis:
- Executive Summary
- Dataset Overview  
- Methodology
- Random Forest Results
- Gradient Boosting Results
- Model Comparison
- Key Findings
- Business Recommendations
- Conclusions
- Technical Appendix

**Features:**
- Table of contents (left sidebar)
- Code folding
- Interactive figures
- Self-contained (single HTML file)
- GitHub-ready

### Presentation Slides (`random_forest_slides.qmd`)
✅ 6 professional slides:
1. **Project Overview** - Objective, dataset, methods
2. **Random Forest Results** - 3 configurations, feature importance
3. **Gradient Boosting Results** - Depth & learning rate analysis
4. **Model Comparison** - Performance head-to-head
5. **Business Impact** - ROI, intervention strategies
6. **Conclusions** - Key findings, recommendations

**Features:**
- RevealJS framework (modern HTML slides)
- Netflix color theme (red/black)
- Slide numbers & navigation
- Responsive design
- Presenter notes

## 🌐 Publishing to GitHub

### Step 1: Push files to GitHub
```bash
git add .
git commit -m "Add Quarto report and slides"
git push origin main
```

### Step 2: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under "Source", select **main branch**
4. Click **Save**

### Step 3: Access your reports
Your files will be available at:
- Report: `https://[username].github.io/[repo]/random_forest_report.html`
- Slides: `https://[username].github.io/[repo]/random_forest_slides.html`

## 🎨 Customization

### Change Colors
Edit `custom.scss`:
```scss
$netflix-red: #E50914;      // Primary color
$netflix-black: #221f1f;    // Text color
$netflix-white: #ffffff;    // Background
```

### Modify Report
Edit `random_forest_report.qmd`:
- Add/remove sections
- Adjust YAML options
- Change theme (`cosmo`, `flatly`, `darkly`, etc.)

### Modify Slides
Edit `random_forest_slides.qmd`:
- Add/remove slides
- Change transition effects
- Adjust layout

## 🔧 Advanced Options

### Preview with Live Reload
```bash
quarto preview random_forest_report.qmd    # Auto-refresh on save
quarto preview random_forest_slides.qmd
```

### Export to PDF
```bash
quarto render random_forest_report.qmd --to pdf
quarto render random_forest_slides.qmd --to pdf
```

### Export to Word
```bash
quarto render random_forest_report.qmd --to docx
```

## 📁 File Structure

```
project/
├── random_forest.ipynb           # Original notebook
├── random_forest_report.qmd      # ← Full HTML report
├── random_forest_slides.qmd      # ← 6-slide presentation
├── custom.scss                   # ← Netflix styling
├── README.md                     # ← GitHub documentation
├── render_quarto.sh              # ← Rendering script
├── random_forest_report.html     # Generated report
└── random_forest_slides.html     # Generated slides
```

## 💡 Tips

1. **Self-contained**: Both outputs are single HTML files (no external dependencies)
2. **Mobile-friendly**: Responsive design works on phones/tablets
3. **Print-ready**: Both can be printed to PDF from browser
4. **Searchable**: Full-text search works in HTML
5. **Interactive**: Slides have keyboard navigation (arrows, space)

## ⌨️ Slide Navigation

- **Next slide**: Space, →, ↓
- **Previous slide**: ←, ↑  
- **First slide**: Home
- **Last slide**: End
- **Slide overview**: Esc or O
- **Speaker view**: S
- **Fullscreen**: F

## 🐛 Troubleshooting

**Quarto not found:**
```bash
# Check installation
quarto --version

# If missing, install from https://quarto.org
```

**Rendering errors:**
```bash
# Check YAML syntax
quarto check random_forest_report.qmd

# Preview to see errors
quarto preview random_forest_report.qmd
```

**GitHub Pages not showing:**
- Wait 5-10 minutes after enabling
- Check file names match exactly
- Ensure HTML files are in root or docs/ folder

## 📞 Need Help?

- Quarto Docs: https://quarto.org/docs/
- RevealJS Docs: https://revealjs.com/
- GitHub Pages: https://pages.github.com/

---

**You're all set!** Run `./render_quarto.sh` to generate your HTML report and slides! 🚀
