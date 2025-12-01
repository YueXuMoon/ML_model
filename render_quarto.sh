#!/bin/bash
# Quarto Rendering Commands for Netflix Churn Prediction Project

echo "==================================================================="
echo "Netflix User Churn Prediction - Quarto Rendering Guide"
echo "==================================================================="

# Check if Quarto is installed
if ! command -v quarto &> /dev/null
then
    echo "❌ Quarto is not installed!"
    echo "Install from: https://quarto.org/docs/get-started/"
    echo ""
    echo "macOS: brew install quarto"
    echo "Or download from website"
    exit 1
fi

echo "✅ Quarto is installed!"
echo ""

# Render HTML Report
echo "==================================================================="
echo "1. Rendering HTML Report (Full Analysis)"
echo "==================================================================="
quarto render random_forest_report.qmd

if [ $? -eq 0 ]; then
    echo "✅ HTML report generated successfully!"
    echo "   📄 File: random_forest_report.html"
    echo ""
else
    echo "❌ Error rendering HTML report"
    exit 1
fi

# Render Presentation Slides
echo "==================================================================="
echo "2. Rendering Presentation Slides (6 Slides)"
echo "==================================================================="
quarto render random_forest_slides.qmd

if [ $? -eq 0 ]; then
    echo "✅ Presentation slides generated successfully!"
    echo "   🎤 File: random_forest_slides.html"
    echo ""
else
    echo "❌ Error rendering presentation slides"
    exit 1
fi

# Show output files
echo "==================================================================="
echo "Generated Files:"
echo "==================================================================="
ls -lh random_forest_report.html 2>/dev/null && echo "  ✅ HTML Report"
ls -lh random_forest_slides.html 2>/dev/null && echo "  ✅ Presentation Slides"
echo ""

# Instructions for viewing
echo "==================================================================="
echo "How to View:"
echo "==================================================================="
echo "1. Open in browser:"
echo "   open random_forest_report.html    # macOS"
echo "   xdg-open random_forest_report.html # Linux"
echo "   start random_forest_report.html   # Windows"
echo ""
echo "2. For GitHub Pages:"
echo "   - Push to GitHub repository"
echo "   - Go to Settings → Pages"
echo "   - Set source to 'main' branch"
echo "   - Access at: https://[username].github.io/[repo]/random_forest_report.html"
echo ""

# Preview commands
echo "==================================================================="
echo "Preview Commands (with live reload):"
echo "==================================================================="
echo "  quarto preview random_forest_report.qmd    # Preview report"
echo "  quarto preview random_forest_slides.qmd    # Preview slides"
echo ""

echo "✅ All done! Enjoy your Quarto outputs!"
echo "==================================================================="
