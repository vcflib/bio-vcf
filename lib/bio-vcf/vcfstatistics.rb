module BioVcf

  class VcfStatistics

    def initialize
      @count = 0
      @ref_alt_count = {}
    end

    def add rec
      @count += 1
      s = rec.ref+">"+rec.alt[0]
      @ref_alt_count[s] ||= 0
      @ref_alt_count[s] += 1
    end

    def print
      puts "==== Statistics ====================================================="
      @ref_alt_count.sort_by {|k,v| k}.each do |k,v|
        printf k+"\t%d\t%2.0d%%\n",v,(v.to_f/@count*100).round
      end
      puts "Total\t#{@count}"
      puts "====================================================================="
    end
  end

end

