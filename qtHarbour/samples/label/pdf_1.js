(function (){

button.text += ' pocetak pdf_1';

var doc = new jsPDF();

doc.text(20, 20, 'hello, I am Ernad Husremovic.');
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


for (i=1; i<=99999; i++) {

    doc.addPage();

    doc.setFontSize(22);
    doc.text(20, 20, 'This is a title' + i);

    doc.setFontSize(16);
    doc.text(20, 30, 'This is some normal sized text underneath.');

    doc.line(100, 100, 100, 120, 1.0, 'dashed');
    doc.line(100, 100, 120, 100, 1.2, 'dotted');
    doc.line(120, 120, 100, 120, 1.4, 'dashed');
    doc.line(120, 120, 120, 100, 1.6, 'solid');

    doc.rect(140, 140, 10, 10, 'solid');
}

//var fileName = "testFile" + new Date().getSeconds()+".pdf";
//var pdfAsDataURI = doc.output('datauri', {"fileName":fileName});

return doc.output();


})
