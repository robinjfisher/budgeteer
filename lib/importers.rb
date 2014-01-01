Dir.foreach("#{Rails.root}/lib/importers/") do |f|
  if !f.is_a?(String) && f.basename =~ /rb/
    require File.join(f.dirname, f)
  end
end

module Importers
  
end