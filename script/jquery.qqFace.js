// QQ表情插件
(function($){  
	$.fn.qqFace = function(options){
		var defaults = {
			id : 'facebox',
			path : 'face/',
			assign : 'content',
			tip : 'em_'
		};
		var option = $.extend(defaults, options);
		var assign = $('#'+option.assign);
		var id = option.id;
		var path = option.path;
		var tip = option.tip;
		
		if(assign.length<=0){
			alert('缺少表情赋值对象。');
			return false;
		}
		
		$(this).click(function(e){
			var strFace, labFace;
			if($('#'+id).length<=0){
				strFace = '<div id="'+id+'" style="display:none; padding:5px;;" class="qqFace"><ul>';
				for(var i=1; i<=75; i++){
				    //labFace = '['+tip+i+']';
				    labFace = encodeURI('<img src="' + path + i + '.png" border="0" style="width:25px;" />');
				    strFace += '<li><img src="' + path + i + '.png" style="width:25px;" onclick="$(\'#' + option.assign + '\').setCaret();$(\'#' + option.assign + '\').insertAtCaret(\'' + labFace + '\');" /></li>';
				}
				strFace += '</ul><div class="clear"></div></div>';
			}
			$(this).parent().parent().append(strFace);
			//var offset = $(this).position();
			//var top = offset.top + $(this).outerHeight();
			//$('#'+id).css('top',top);
			//$('#'+id).css('left',offset.left);
			$('#'+id).show();
			e.stopPropagation();
		});

		$(document).click(function(){
			$('#'+id).hide();
			$('#'+id).remove();
		});
	};

})(jQuery);

jQuery.extend({ 
unselectContents: function(){ 
	if(window.getSelection) 
		window.getSelection().removeAllRanges(); 
	else if(document.selection) 
		document.selection.empty(); 
	} 
}); 
jQuery.fn.extend({ 
    selectContents: function(){ 
        $(this).each(function(i){ 
            var node = this; 
            var selection, range, doc, win; 
            if ((doc = node.ownerDocument) && (win = doc.defaultView) && typeof win.getSelection != 'undefined' && typeof doc.createRange != 'undefined' && (selection = window.getSelection()) && typeof selection.removeAllRanges != 'undefined'){ 
                range = doc.createRange(); 
                range.selectNode(node); 
                if(i == 0){ 
                    selection.removeAllRanges(); 
                } 
                selection.addRange(range); 
            } else if (document.body && typeof document.body.createTextRange != 'undefined' && (range = document.body.createTextRange())){ 
                range.moveToElementText(node); 
                range.select(); 
            } 
        }); 
    }, 

    setCaret: function () {
        if(!$.browser.msie) return; 
        var initSetCaret = function(){ 
            var textObj = $(this).get(0); 
            textObj.caretPos = document.selection.createRange().duplicate(); 
        }; 
        $(this).click(initSetCaret).select(initSetCaret).keyup(initSetCaret); 
    }, 

    insertAtCaret: function (textFeildValue) {
        var textObj = $(this);
        textObj.html(textObj.html() + decodeURI(textFeildValue));
        //if (document.all && textObj.createTextRange && textObj.caretPos) {
        //    var caretPos = textObj.caretPos;
        //    caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '' ?
		//	textFeildValue + '' : textFeildValue;
        //} else if (textObj.setSelectionRange) {
        //    var rangeStart = textObj.selectionStart;
        //    var rangeEnd = textObj.selectionEnd;
        //    var tempStr1 = textObj.html.substring(0, rangeStart);
        //    var tempStr2 = textObj.html.substring(rangeEnd);
        //    textObj.html = tempStr1 + textFeildValue + tempStr2;
        //    textObj.focus();
        //    var len = textFeildValue.length;
        //    textObj.setSelectionRange(rangeStart + len, rangeStart + len);
        //    textObj.blur();
        //} else {
        //    textObj.html += textFeildValue;
        //}
    }
});