jQuery(function(){

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('form.destroy_link_to').submit(function(){
		if( !confirm('Seriously?') ){
			return false;
		}
	});

	jQuery('p.flash').click(function(){$(this).remove();});

});
