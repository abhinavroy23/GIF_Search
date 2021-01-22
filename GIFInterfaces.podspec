Pod::Spec.new do |s|

# ――― Summary ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.name      = "GIFInterfaces"
s.version   = "0.0.1"
s.summary   = "Protocols for GIF support and caching"
s.homepage  = "https://github.com/abhinavroy23/GIF-Search.git"
s.author    = "Roy, Abhinav"
s.platform  = :ios, "13.0"
s.swift_version   = "5.0"
#s.static_framework = true

# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.source    = { :git => "https://github.com/abhinavroy23/GIF-Search.git", :branch => "master" }

# ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

#Start Framework Dependencies
#End Framework Dependencies

# ――― Contents ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.source_files = ['GIFInterfaces/**/*.swift', 'GIFInterfaces/**/*.{h,m}']

end
