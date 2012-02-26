window = this;

document = {

    createElement: function(tagname) {
           return { nodeName: tagName };
    }
};
