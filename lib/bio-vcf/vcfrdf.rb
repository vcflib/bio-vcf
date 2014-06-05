module BioVcf

  # This is some primarily RDF support - which may be moved to another gem

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
:#{id2} seq:alt #{rec.alt[0]} .
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
end
