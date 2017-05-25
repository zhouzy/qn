function jsonToUrlparam (obj){
    let urlparam = '';
    for (let item in obj){
        urlparam += `${item}=${obj[item]}&`;
    }
    if (urlparam!=''){
        urlparam = urlparam.substr(0, urlparam.length-1);
    }
    return urlparam;
}

export default {
    jsonToUrlparam
}