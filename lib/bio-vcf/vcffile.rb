module BioVcf
    # This class abstracts a VCF file that can be iterated. 
    # The VCF can be plain text or compressed with gzip
    # Note that files compressed with bgzip will not work, as thie ruby implementation of Zlib don't allow concatenated files
    class VCFfile
    
        def initialize(file: "", is_gz: true)
            @file = file
            @is_gz = is_gz
        end
    
        def parseVCFheader(head_line="")
            m=/##INFO=<ID=(.+),Number=(.+),Type=(.+),Description="(.+)">/.match(head_line)
            {:id=>m[1],:number=>m[2],:type=>m[3],:desc=>m[4]}
        end
    
    
        #Returns an enum that can be used as an iterator. 
        def each
            return enum_for(:each) unless block_given? 
            io = nil
            if @is_gz
                infile = open(@file)
                io = Zlib::GzipReader.new(infile) 
            else
                io =  File.open(@file)
            end
            
            header = BioVcf::VcfHeader.new 
            io.each_line do |line|  
                line.chomp!
                if line =~ /^##fileformat=/
                    header.add(line)  
                    next
                end
                if line =~ /^#/
                    header.add(line)
                    next
                end
                fields = BioVcf::VcfLine.parse(line)
                rec    = BioVcf::VcfRecord.new(fields,header)
                yield rec
            end
        end
    end
end