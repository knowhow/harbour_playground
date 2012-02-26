button.text += ' pocetak pdf_1';

var doc = new pdf();

button.text += ' pocetak pdf_1+1';


doc.text(20, 20, 'hello, I am PDF.');
doc.text(20, 30, 'i was created in the browser using javascript.');
doc.text(20, 40, 'i can also be created from node.js');

/* Optional - set properties on the document */
doc.setProperties({
        title: 'A sample document created by pdf.js',
        subject: 'PDFs are kinda cool, i guess',    
        author: 'Marak Squires',
        keywords: 'pdf.js, javascript, Marak, Marak Squires',
        creator: 'pdf.js'
});
doc.addPage();

doc.setFontSize(22);
doc.text(20, 20, 'This is a title');

doc.setFontSize(16);
doc.text(20, 30, 'This is some normal sized text underneath.');

doc.drawLine(100, 100, 100, 120, 1.0, 'dashed');
doc.drawLine(100, 100, 120, 100, 1.2, 'dotted');
doc.drawLine(120, 120, 100, 120, 1.4, 'dashed');
doc.drawLine(120, 120, 120, 100, 1.6, 'solid');

doc.drawRect(140, 140, 10, 10, 'solid');

var fileName = "testFile" + new Date().getSeconds()+".pdf";
var pdfAsDataURI = doc.output('datauri', {"fileName":fileName});

button.text += 'kkkkkk pdf_1';


