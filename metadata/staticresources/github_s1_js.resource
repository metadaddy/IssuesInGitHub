// Utility functions to navigate to URLs and SObjects

function navigateToURL(url) {
    if( (typeof sforce != 'undefined') && (sforce != null) ) {
        console.log('navigateToURL',url);
        sforce.one.navigateToURL(url);
    } else {
        console.log('document.location',url);
        document.location = url;
    }
}
            
function navigateToSObject(id) {
    if( (typeof sforce != 'undefined') && (sforce != null) ) {
        console.log('navigateToSObject',id);
        sforce.one.navigateToSObject(id);
    } else {
        console.log('document.location',id);
        document.location = '/'+id;
    }
}