BEGIN {
	chomp ($now=qx/date +%Y%m%d/)
};

/(\d{8})(\d{2})(\s+;\s+serial)/i and do {
	$serial = ($1 eq $now ? $2+1 : 0);
	s/\d{8}(\d{2})/sprintf "%8d%02d",$now,$serial/e;
}
