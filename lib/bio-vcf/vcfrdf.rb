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
@prefix : <http://biobeat.org/rdf/ns#> .
EOB
    end

    def VcfRdf::record id,rec,hash = {}
      id2 = [id,'ch'+rec.chrom,rec.pos].join('_')
      print <<OUT
:#{id2} :chr \"#{rec.chrom}\" .
:#{id2} :pos #{rec.pos} .
:#{id2} :vcf true .
OUT
      hash.each do |k,v|
        print ":#{id2} :#{k} #{v} .\n"
      end
    end
  end
end
