
#	While a HWIA does not differentiate strings and symbols,
#	it does not differentiate between strings and numbers.
YNORDK = HashWithIndifferentAccess.new({
	:yes   => 1,
	:true  => 1,
	:no    => 2,
	:false => 2,
	:other => 3,
	:dk    => 999,
	:refused => 0,
	'0'    => 'Refused',
	'1'    => 'Yes',
	'2'    => 'No',
	'3'    => 'Other',
	'999'  => "Don't Know",
	0      => 'Refused',
	1      => 'Yes',
	2      => 'No',
	3      => 'Other',
	999    => "Don't Know"
}).freeze	
#	YNORDK includes all, but isn't actually used.
#	Just the following are. Perhaps should define each separately?
YNDK  = YNORDK;
YNODK = YNORDK;
YNRDK = YNORDK;

ADNA = HashWithIndifferentAccess.new({
	:agree => 1,
	:disagree => 2,
	:na    => 888,
	:dk    => 999,
	'1'    => 'Agree',
	'2'    => 'Do Not Agree',
	'888'  => 'N/A',
	'999'  => "Don't Know",
	1      => 'Agree',
	2      => 'Do Not Agree',
	888    => 'N/A',
	999    => "Don't Know"
}).freeze

#	methods or constants?
def valid_yndk_values
	[1,2,999]
end
def valid_ynodk_values
	[1,2,3,999]
end
def valid_ynrdk_values
	[0,1,2,999]
end
def valid_adna_values
	[1,2,888,999]
end
