module BioVcf

  # This is some primarily RDF support - which may be moved to another gem
  #
  # Note that this functionality is superceded by the --template command! Though
  # this can be useful for one-liners.

  module VcfRdf

    def VcfRdf::header
      print <<EOB
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix hgnc: <http://identifiers.org/hgnc.symbol/> .
@prefix doi: <http://dx.doi.org/> .
@prefix db: <http://biobeat.org/rdf/db#> .
@prefix seq: <http://biobeat.org/rdf/seq#> .
@prefix : <http://biobeat.org/rdf/vcf#> .
EOB
    end

    def VcfRdf::record id,rec,tags = "{}"
      id2 = [id,'ch'+rec.chrom,rec.pos,rec.alt.join('')].join('_')
      print <<OUT
:#{id2} seq:chr \"#{rec.chrom}\" .
:#{id2} seq:pos #{rec.pos} .
:#{id2} seq:alt \"#{rec.alt[0]}\" .
:#{id2} db:vcf true .
OUT
      hash = eval(tags)
      if hash
        hash.each do |k,v|
          print ":#{id2} #{k} #{v} .\n"
        end
      end
      print "\n"
    end
  end


# RDF support module. Original is part of bioruby-rdf by Pjotr Prins
#

  module RDF

    def RDF::valid_uri? uri
      uri =~ /^([!#$&-;=?_a-z~]|%[0-9a-f]{2})+$/i
    end

    def RDF::escape_string_literal(literal)
      s = literal.to_s
      # Put a slash before every double quote if there is no such slash already
      s = s.gsub(/(?<!\\)"/,'\"')
      # Put a slash before a single slash if it is not \["utnr>\]
      if s =~ /[^\\]\\[^\\]/
        s2 = []
        s.each_char.with_index { |c,i| 
          res = c
          if i>0 and c == '\\' and s[i-1] != '\\' and s[i+1] !~ /^[uUtnr\\"]/
            res = '\\' + c
          end
          # p [i,c,s[i+1],res]
          s2 << res
        }
        s = s2.join('')
      end
      s
    end

    def RDF::stringify_literal(literal)
      RDF::escape_string_literal(literal.to_s)
    end

    def RDF::quoted_stringify_literal(literal)
      '"' + stringify_literal(literal) + '"'
    end
  end

  module Turtle

    def Turtle::stringify_literal(literal)
      RDF::stringify_literal(literal)
    end

    def Turtle::identifier(id)
      raise "Illegal identifier #{id}" if id != Turtle::mangle_identifier(id)
    end

    # Replace letters/symbols that are not allowed in a Turtle identifier
    # (short hand URI). This should be the definite mangler and replace the 
    # ones in bioruby-table and bio-exominer. Manglers are useful when using
    # data from other sources and trying to transform them into simple RDF 
    # identifiers.

    def Turtle::mangle_identifier(s)
      id = s.strip.gsub(/[^[:print:]]/, '').gsub(/[#)(,]/,"").gsub(/[%]/,"perc").gsub(/(\s|\.|\$|\/|\\|\>)+/,"_")
      id = id.gsub(/\[|\]/,'')
      # id = URI::escape(id)
      id = id.gsub(/\|/,'_')
      id = id.gsub(/\-|:/,'_')
      if id != s 
        # Don't want Bio depency in templates!
        # logger = Bio::Log::LoggerPlus.new 'bio-rdf'
        # logger.warn "\nWARNING: Changed identifier <#{s}> to <#{id}>"
        # $stderr.print "\nWARNING: Changed identifier <#{s}> to <#{id}>"
      end
      if not RDF::valid_uri?(id)
        raise "Invalid URI after mangling <#{s}> to <#{id}>!"
      end
      valid_id = if id =~ /^\d/
                   'r' + id
                 else
                   id
                 end
      valid_id  # we certainly hope so!
    end
  end
end
