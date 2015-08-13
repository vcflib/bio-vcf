# require 'mini/test'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'bio-vcf'

require 'rspec/expectations'

# Add the regression module if in the path (it can also be a gem)
rootdir = File.dirname(__FILE__) + '/../..'
$LOAD_PATH.unshift(rootdir+'/lib',rootdir+'/../regressiontest/lib')
require 'regressiontest'

include BioVcf
