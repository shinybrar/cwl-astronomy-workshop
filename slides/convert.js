const { convert } = require('./html2pptx/index.cjs');
const fs = require('fs');
const path = require('path');

async function convertSlides() {
    const slidesDir = __dirname;
    const slideFiles = fs.readdirSync(slidesDir)
        .filter(f => f.startsWith('slide') && f.endsWith('.html'))
        .sort();
    
    console.log(`Found ${slideFiles.length} slides to convert`);
    
    const slides = slideFiles.map(file => {
        const content = fs.readFileSync(path.join(slidesDir, file), 'utf-8');
        return { html: content };
    });
    
    const pptxBuffer = await convert(slides, {
        width: 10,
        height: 5.625,
        css: fs.readFileSync(path.join(slidesDir, 'styles.css'), 'utf-8')
    });
    
    fs.writeFileSync(path.join(slidesDir, 'cwl-workshop-slides.pptx'), pptxBuffer);
    console.log('Created cwl-workshop-slides.pptx');
}

convertSlides().catch(console.error);
