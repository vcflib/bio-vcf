module BioVcf

  class BedFilter
    def initialize bedfilen
      require 'binary_search/native'

      # Parse Bed file and build up search array
      chrs = {}
      info = {}
      File.open(bedfilen).each_line { | line |
        (chr,start,stop,gene) = line.strip.split(/\t/)[0..3]
        chrs[chr] ||= []
        chrs[chr].push(stop.to_i)
        info[chr+':'+stop] = [chr,start.to_i,stop.to_i,gene]
      }
      # Make sure chrs is sorted
      @chrs = {}
      chrs.each { | k,list |
        @chrs[k] = list.sort
      }
      @info = info
    end

    def contains(rec)
      stop_list = @chrs[rec.chrom]
      if stop_list
        pos = rec.pos
        stop = stop_list.bsearch { |bedstop| bedstop >= pos }
        if stop
          rinfo = @info[rec.chrom+':'+stop.to_s]
          raise "Unexpected error in BED record for #{rec.chrom}:#{stop} position" if rinfo == nil
          start = rinfo[1]
          if pos >= start
            # p [rec.chrom,rec.pos,rinfo]
            return rinfo
          end
        end
      end
      nil
    end
  end

end
