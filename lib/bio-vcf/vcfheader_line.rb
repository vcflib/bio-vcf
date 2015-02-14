
# line 1 "gen_vcfheaderline_parser.rl"
# Ragel lexer for VCF-header
#
# This is compact a parser/lexer for the VCF header format. Bio-vcf
# uses the parser to generate meta information that can be output to
# (for example) JSON format. The advantage of using ragel as a state
# engine is that it allows for easy parsing of key-value pairs with
# syntax checking and, for example, escaped quotes in quoted string
# values. This ragel parser/lexer generates valid Ruby; it should be
# fairly trivial to generate python/C/JAVA instead. Note that this
# edition validates ID and Number fields only.  Other fields are
# dumped 'AS IS'.
#
# Note the .rb version is generated from ./ragel/gen_vcfheaderline_parser.rl
#
# by Pjotr Prins (c) 2014/2015

module BioVcf

  module VcfHeaderParser

    module RagelKeyValues

      def self.debug msg
        # nothing
	# $stderr.print "DEBUG: ",msg,"\n"
      end
      
=begin

# line 75 "gen_vcfheaderline_parser.rl"

=end


# line 38 "gen_vcfheaderline_parser.rb"
class << self
	attr_accessor :_simple_lexer_actions
	private :_simple_lexer_actions, :_simple_lexer_actions=
end
self._simple_lexer_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 15, 1, 16, 2, 0, 1, 
	2, 4, 15, 2, 6, 15, 2, 7, 
	15, 2, 9, 16, 2, 10, 16, 2, 
	11, 16, 2, 12, 15, 2, 13, 16, 
	2, 14, 16, 3, 5, 8, 15, 6, 
	9, 10, 13, 11, 14, 16
]

class << self
	attr_accessor :_simple_lexer_key_offsets
	private :_simple_lexer_key_offsets, :_simple_lexer_key_offsets=
end
self._simple_lexer_key_offsets = [
	0, 0, 1, 2, 7, 8, 9, 10, 
	13, 26, 35, 49, 51, 53, 58, 60, 
	62, 62, 62, 64, 70, 72, 77, 80, 
	91, 101, 111, 121, 131, 141, 151, 161, 
	171, 181, 191, 201, 211, 221, 231, 241, 
	251, 261, 270, 275, 277, 279, 279, 281, 
	283, 283, 293, 303, 313, 322, 327, 329, 
	331, 331, 333, 335, 335, 345, 354, 360, 
	371, 381, 391, 401, 411, 421, 430, 438, 
	440, 445, 448, 458, 468, 478, 488, 498, 
	508, 517, 524, 526, 528, 533, 535, 537, 
	537, 537, 549, 559, 569, 579, 589, 599, 
	609, 619, 629, 639, 649, 659, 669, 671, 
	672, 673, 674, 675, 676, 677, 678, 679, 
	680, 681, 682, 683, 684, 685, 686, 687, 
	688, 689, 690, 691, 692, 693, 694, 695, 
	696, 697, 698, 699, 700
]

class << self
	attr_accessor :_simple_lexer_trans_keys
	private :_simple_lexer_trans_keys, :_simple_lexer_trans_keys=
end
self._simple_lexer_trans_keys = [
	35, 35, 65, 70, 71, 73, 99, 76, 
	84, 61, 44, 60, 62, 67, 68, 73, 
	78, 86, 97, 108, 48, 57, 65, 90, 
	98, 122, 46, 61, 95, 48, 57, 65, 
	90, 97, 122, 34, 39, 44, 46, 60, 
	62, 43, 45, 48, 57, 65, 90, 97, 
	122, 34, 92, 34, 92, 34, 39, 44, 
	60, 62, 39, 92, 39, 92, 48, 57, 
	44, 46, 60, 62, 48, 57, 48, 57, 
	44, 60, 62, 48, 57, 44, 60, 62, 
	44, 46, 60, 62, 95, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 111, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	109, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 109, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 97, 48, 57, 65, 
	90, 98, 122, 46, 61, 95, 110, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	100, 48, 57, 65, 90, 97, 122, 46, 
	61, 76, 95, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 105, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 110, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	101, 48, 57, 65, 90, 97, 122, 46, 
	61, 79, 95, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 112, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 116, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	105, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 111, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 110, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 115, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	48, 57, 65, 90, 97, 122, 34, 39, 
	44, 60, 62, 34, 92, 34, 92, 39, 
	92, 39, 92, 46, 61, 95, 97, 48, 
	57, 65, 90, 98, 122, 46, 61, 95, 
	116, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 101, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 48, 57, 65, 90, 
	97, 122, 34, 39, 44, 60, 62, 34, 
	92, 34, 92, 39, 92, 39, 92, 46, 
	61, 68, 95, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 48, 57, 65, 90, 
	97, 122, 48, 57, 65, 90, 97, 122, 
	44, 46, 60, 62, 95, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 117, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	109, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 98, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 101, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 114, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	48, 57, 65, 90, 97, 122, 43, 45, 
	46, 65, 71, 82, 48, 57, 48, 57, 
	44, 60, 62, 48, 57, 44, 60, 62, 
	46, 61, 95, 101, 48, 57, 65, 90, 
	97, 122, 46, 61, 95, 114, 48, 57, 
	65, 90, 97, 122, 46, 61, 95, 115, 
	48, 57, 65, 90, 97, 122, 46, 61, 
	95, 105, 48, 57, 65, 90, 97, 122, 
	46, 61, 95, 111, 48, 57, 65, 90, 
	97, 122, 46, 61, 95, 110, 48, 57, 
	65, 90, 97, 122, 46, 61, 95, 48, 
	57, 65, 90, 97, 122, 34, 39, 44, 
	60, 62, 48, 57, 34, 92, 34, 92, 
	34, 39, 44, 60, 62, 39, 92, 39, 
	92, 44, 60, 62, 95, 45, 46, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	115, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 115, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 101, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 109, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	98, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 108, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 121, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 101, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	110, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 103, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 116, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 104, 48, 
	57, 65, 90, 97, 122, 73, 79, 76, 
	84, 69, 82, 82, 77, 65, 65, 84, 
	75, 67, 111, 109, 109, 97, 110, 100, 
	76, 105, 110, 101, 78, 70, 79, 111, 
	110, 116, 105, 103, 0
]

class << self
	attr_accessor :_simple_lexer_single_lengths
	private :_simple_lexer_single_lengths, :_simple_lexer_single_lengths=
end
self._simple_lexer_single_lengths = [
	0, 1, 1, 5, 1, 1, 1, 3, 
	7, 3, 6, 2, 2, 5, 2, 2, 
	0, 0, 0, 4, 0, 3, 3, 5, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 3, 5, 2, 2, 0, 2, 2, 
	0, 4, 4, 4, 3, 5, 2, 2, 
	0, 2, 2, 0, 4, 3, 0, 5, 
	4, 4, 4, 4, 4, 3, 6, 0, 
	3, 3, 4, 4, 4, 4, 4, 4, 
	3, 5, 2, 2, 5, 2, 2, 0, 
	0, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 2, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 0
]

class << self
	attr_accessor :_simple_lexer_range_lengths
	private :_simple_lexer_range_lengths, :_simple_lexer_range_lengths=
end
self._simple_lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	3, 3, 4, 0, 0, 0, 0, 0, 
	0, 0, 1, 1, 1, 1, 0, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 0, 0, 0, 0, 0, 0, 
	0, 3, 3, 3, 3, 0, 0, 0, 
	0, 0, 0, 0, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 1, 1, 
	1, 0, 3, 3, 3, 3, 3, 3, 
	3, 1, 0, 0, 0, 0, 0, 0, 
	0, 4, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_simple_lexer_index_offsets
	private :_simple_lexer_index_offsets, :_simple_lexer_index_offsets=
end
self._simple_lexer_index_offsets = [
	0, 0, 2, 4, 10, 12, 14, 16, 
	20, 31, 38, 49, 52, 55, 61, 64, 
	67, 68, 69, 71, 77, 79, 84, 88, 
	97, 105, 113, 121, 129, 137, 145, 153, 
	161, 169, 177, 185, 193, 201, 209, 217, 
	225, 233, 240, 246, 249, 252, 253, 256, 
	259, 260, 268, 276, 284, 291, 297, 300, 
	303, 304, 307, 310, 311, 319, 326, 330, 
	339, 347, 355, 363, 371, 379, 386, 394, 
	396, 401, 405, 413, 421, 429, 437, 445, 
	453, 460, 467, 470, 473, 479, 482, 485, 
	486, 487, 496, 504, 512, 520, 528, 536, 
	544, 552, 560, 568, 576, 584, 592, 595, 
	597, 599, 601, 603, 605, 607, 609, 611, 
	613, 615, 617, 619, 621, 623, 625, 627, 
	629, 631, 633, 635, 637, 639, 641, 643, 
	645, 647, 649, 651, 653
]

class << self
	attr_accessor :_simple_lexer_trans_targs
	private :_simple_lexer_trans_targs, :_simple_lexer_trans_targs=
end
self._simple_lexer_trans_targs = [
	2, 0, 3, 0, 4, 102, 110, 124, 
	127, 0, 5, 0, 6, 0, 7, 0, 
	8, 8, 132, 0, 24, 49, 60, 64, 
	74, 90, 97, 9, 9, 9, 0, 9, 
	10, 9, 9, 9, 9, 0, 11, 14, 
	8, 22, 8, 132, 18, 23, 23, 23, 
	0, 13, 17, 12, 13, 17, 12, 11, 
	14, 8, 8, 132, 0, 13, 16, 15, 
	13, 16, 15, 15, 12, 19, 0, 8, 
	20, 8, 132, 19, 0, 21, 0, 8, 
	8, 132, 21, 0, 8, 8, 132, 0, 
	8, 23, 8, 132, 23, 23, 23, 23, 
	0, 9, 10, 9, 25, 9, 9, 9, 
	0, 9, 10, 9, 26, 9, 9, 9, 
	0, 9, 10, 9, 27, 9, 9, 9, 
	0, 9, 10, 9, 28, 9, 9, 9, 
	0, 9, 10, 9, 29, 9, 9, 9, 
	0, 9, 10, 9, 30, 9, 9, 9, 
	0, 9, 10, 31, 9, 9, 9, 9, 
	0, 9, 10, 9, 32, 9, 9, 9, 
	0, 9, 10, 9, 33, 9, 9, 9, 
	0, 9, 10, 9, 34, 9, 9, 9, 
	0, 9, 10, 35, 9, 9, 9, 9, 
	0, 9, 10, 9, 36, 9, 9, 9, 
	0, 9, 10, 9, 37, 9, 9, 9, 
	0, 9, 10, 9, 38, 9, 9, 9, 
	0, 9, 10, 9, 39, 9, 9, 9, 
	0, 9, 10, 9, 40, 9, 9, 9, 
	0, 9, 10, 9, 41, 9, 9, 9, 
	0, 9, 42, 9, 9, 9, 9, 0, 
	43, 46, 8, 8, 132, 0, 42, 45, 
	44, 42, 45, 44, 44, 42, 48, 47, 
	42, 48, 47, 47, 9, 10, 9, 50, 
	9, 9, 9, 0, 9, 10, 9, 51, 
	9, 9, 9, 0, 9, 10, 9, 52, 
	9, 9, 9, 0, 9, 53, 9, 9, 
	9, 9, 0, 54, 57, 8, 8, 132, 
	0, 53, 56, 55, 53, 56, 55, 55, 
	53, 59, 58, 53, 59, 58, 58, 9, 
	10, 61, 9, 9, 9, 9, 0, 9, 
	62, 9, 9, 9, 9, 0, 63, 63, 
	63, 0, 8, 63, 8, 132, 63, 63, 
	63, 63, 0, 9, 10, 9, 65, 9, 
	9, 9, 0, 9, 10, 9, 66, 9, 
	9, 9, 0, 9, 10, 9, 67, 9, 
	9, 9, 0, 9, 10, 9, 68, 9, 
	9, 9, 0, 9, 10, 9, 69, 9, 
	9, 9, 0, 9, 70, 9, 9, 9, 
	9, 0, 71, 71, 73, 73, 73, 73, 
	72, 0, 72, 0, 8, 8, 132, 72, 
	0, 8, 8, 132, 0, 9, 10, 9, 
	75, 9, 9, 9, 0, 9, 10, 9, 
	76, 9, 9, 9, 0, 9, 10, 9, 
	77, 9, 9, 9, 0, 9, 10, 9, 
	78, 9, 9, 9, 0, 9, 10, 9, 
	79, 9, 9, 9, 0, 9, 10, 9, 
	80, 9, 9, 9, 0, 9, 81, 9, 
	9, 9, 9, 0, 82, 85, 8, 8, 
	132, 89, 0, 84, 88, 83, 84, 88, 
	83, 82, 85, 8, 8, 132, 0, 84, 
	87, 86, 84, 87, 86, 86, 83, 8, 
	8, 132, 89, 89, 89, 89, 89, 0, 
	9, 10, 9, 91, 9, 9, 9, 0, 
	9, 10, 9, 92, 9, 9, 9, 0, 
	9, 10, 9, 93, 9, 9, 9, 0, 
	9, 10, 9, 94, 9, 9, 9, 0, 
	9, 10, 9, 95, 9, 9, 9, 0, 
	9, 10, 9, 96, 9, 9, 9, 0, 
	9, 10, 9, 61, 9, 9, 9, 0, 
	9, 10, 9, 98, 9, 9, 9, 0, 
	9, 10, 9, 99, 9, 9, 9, 0, 
	9, 10, 9, 100, 9, 9, 9, 0, 
	9, 10, 9, 101, 9, 9, 9, 0, 
	9, 10, 9, 69, 9, 9, 9, 0, 
	103, 107, 0, 104, 0, 105, 0, 106, 
	0, 6, 0, 108, 0, 109, 0, 5, 
	0, 111, 0, 112, 0, 113, 0, 114, 
	0, 115, 0, 116, 0, 117, 0, 118, 
	0, 119, 0, 120, 0, 121, 0, 122, 
	0, 123, 0, 6, 0, 125, 0, 126, 
	0, 6, 0, 128, 0, 129, 0, 130, 
	0, 131, 0, 6, 0, 0, 0
]

class << self
	attr_accessor :_simple_lexer_trans_actions
	private :_simple_lexer_trans_actions, :_simple_lexer_trans_actions=
end
self._simple_lexer_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 47, 0, 
	7, 0, 0, 0, 0, 11, 0, 0, 
	9, 0, 9, 9, 0, 1, 1, 1, 
	0, 13, 1, 1, 3, 0, 0, 0, 
	0, 9, 9, 9, 0, 13, 1, 1, 
	3, 0, 0, 0, 0, 0, 11, 9, 
	0, 9, 9, 0, 0, 0, 11, 9, 
	9, 9, 0, 0, 9, 9, 9, 0, 
	16, 0, 16, 16, 0, 0, 0, 0, 
	0, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 7, 0, 0, 0, 0, 0, 
	40, 0, 5, 0, 0, 0, 0, 40, 
	0, 0, 9, 9, 9, 0, 13, 1, 
	1, 3, 0, 0, 0, 13, 1, 1, 
	3, 0, 0, 0, 0, 7, 0, 0, 
	0, 0, 0, 37, 0, 7, 0, 0, 
	0, 0, 0, 37, 0, 7, 0, 0, 
	0, 0, 0, 37, 0, 5, 0, 0, 
	0, 0, 37, 0, 0, 34, 34, 34, 
	0, 13, 1, 1, 3, 0, 0, 0, 
	13, 1, 1, 3, 0, 0, 0, 0, 
	7, 0, 0, 0, 0, 0, 25, 0, 
	5, 0, 0, 0, 0, 25, 1, 1, 
	1, 25, 43, 0, 43, 43, 0, 0, 
	0, 0, 0, 0, 7, 0, 0, 0, 
	0, 0, 31, 0, 7, 0, 0, 0, 
	0, 0, 31, 0, 7, 0, 0, 0, 
	0, 0, 31, 0, 7, 0, 0, 0, 
	0, 0, 31, 0, 7, 0, 0, 0, 
	0, 0, 31, 0, 5, 0, 0, 0, 
	0, 31, 1, 1, 1, 1, 1, 1, 
	1, 31, 0, 31, 22, 22, 22, 0, 
	0, 22, 22, 22, 0, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 7, 0, 
	0, 0, 0, 0, 28, 0, 5, 0, 
	0, 0, 0, 28, 0, 0, 9, 9, 
	9, 1, 0, 13, 1, 1, 3, 0, 
	0, 0, 0, 9, 9, 9, 0, 13, 
	1, 1, 3, 0, 0, 0, 0, 19, 
	19, 19, 0, 0, 0, 0, 0, 0, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 25, 
	0, 7, 0, 0, 0, 0, 0, 31, 
	0, 7, 0, 0, 0, 0, 0, 31, 
	0, 7, 0, 0, 0, 0, 0, 31, 
	0, 7, 0, 0, 0, 0, 0, 31, 
	0, 7, 0, 0, 0, 0, 0, 31, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_simple_lexer_eof_actions
	private :_simple_lexer_eof_actions, :_simple_lexer_eof_actions=
end
self._simple_lexer_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	47, 11, 0, 11, 11, 0, 11, 11, 
	11, 11, 11, 0, 11, 0, 0, 0, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 0, 40, 40, 40, 40, 40, 
	40, 37, 37, 37, 37, 0, 37, 37, 
	37, 37, 37, 37, 25, 25, 25, 0, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	0, 0, 28, 28, 28, 28, 28, 28, 
	28, 0, 28, 28, 0, 28, 28, 28, 
	28, 0, 25, 25, 25, 25, 25, 25, 
	25, 31, 31, 31, 31, 31, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :simple_lexer_start
end
self.simple_lexer_start = 1;
class << self
	attr_accessor :simple_lexer_first_final
end
self.simple_lexer_first_final = 132;
class << self
	attr_accessor :simple_lexer_error
end
self.simple_lexer_error = 0;

class << self
	attr_accessor :simple_lexer_en_main
end
self.simple_lexer_en_main = 1;


# line 79 "gen_vcfheaderline_parser.rl"
# %% this just fixes syntax highlighting...

def self.run_lexer(buf, options = {})
  do_debug = (options[:debug] == true)
  $stderr.print "---> ",buf,"\n" if do_debug
  data = buf.unpack("c*") if(buf.is_a?(String))
  eof = data.length
  values = []
  stack = []

  emit = lambda { |type, data, ts, p|
    # Print the type and text of the last read token
    # p ts,p
    $stderr.print "EMITTED: #{type}: #{data[ts...p].pack('c*')}\n" if do_debug
    values << [type,data[ts...p].pack('c*')]
  }

  error_code = nil
  
  
# line 486 "gen_vcfheaderline_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = simple_lexer_start
end

# line 99 "gen_vcfheaderline_parser.rl"
  
# line 495 "gen_vcfheaderline_parser.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _simple_lexer_key_offsets[cs]
	_trans = _simple_lexer_index_offsets[cs]
	_klen = _simple_lexer_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _simple_lexer_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _simple_lexer_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _simple_lexer_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _simple_lexer_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _simple_lexer_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	cs = _simple_lexer_trans_targs[_trans]
	if _simple_lexer_trans_actions[_trans] != 0
		_acts = _simple_lexer_trans_actions[_trans]
		_nacts = _simple_lexer_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _simple_lexer_actions[_acts - 1]
when 0 then
# line 33 "gen_vcfheaderline_parser.rl"
		begin
 ts=p 		end
when 1 then
# line 34 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:value,data,ts,p)
  		end
when 2 then
# line 38 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:kw,data,ts,p)
  		end
when 3 then
# line 58 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:key_word,data,ts,p) 		end
when 4 then
# line 59 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 5 then
# line 60 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 6 then
# line 62 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 7 then
# line 65 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 8 then
# line 67 "gen_vcfheaderline_parser.rl"
		begin
 debug("ID FOUND") 		end
when 9 then
# line 67 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 10 then
# line 68 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Version"		end
when 11 then
# line 69 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 12 then
# line 70 "gen_vcfheaderline_parser.rl"
		begin
 debug("DATE FOUND") 		end
when 13 then
# line 70 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Date"		end
when 14 then
# line 71 "gen_vcfheaderline_parser.rl"
		begin
 error_code="GATK"		end
when 15 then
# line 72 "gen_vcfheaderline_parser.rl"
		begin
 debug("KEY_VALUE found") 		end
when 16 then
# line 72 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 647 "gen_vcfheaderline_parser.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	__acts = _simple_lexer_eof_actions[cs]
	__nacts =  _simple_lexer_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _simple_lexer_actions[__acts - 1]
when 9 then
# line 67 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 10 then
# line 68 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Version"		end
when 11 then
# line 69 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 13 then
# line 70 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Date"		end
when 14 then
# line 71 "gen_vcfheaderline_parser.rl"
		begin
 error_code="GATK"		end
when 16 then
# line 72 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 699 "gen_vcfheaderline_parser.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 100 "gen_vcfheaderline_parser.rl"

  raise "ERROR: "+error_code+" in "+buf if error_code

  begin
    res = {}
    # p values
    values.each_slice(2) do | a,b |
      $stderr.print '*',a,b if do_debug
      keyword = a[1]
      value = b[1]
      value = value.to_i if ['length','Epoch'].index(keyword)
      res[keyword] = value
      # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
    end
  rescue
    print "ERROR: "
    p values
    raise
  end
  $stderr.print(res,"\n") if do_debug
  res
end
    end
  end 
end

if __FILE__ == $0

gatkcommandline = <<LINE1
##GATKCommandLine=<ID=CombineVariants,Version=3.2-2-gec30cee,Date="Thu Oct 30 13:41:59 CET 2014",Epoch=1414672919266,CommandLineOptions="analysis_type=CombineVariants input_file=[] showFullBamList=false read_buffer_size=null phone_home=AWS gatk_key=null tag=NA read_filter=[] intervals=null excludeIntervals=null interval_set_rule=UNION interval_merging=ALL interval_padding=0 reference_sequence=/hpc/cog_bioinf/GENOMES/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta nonDeterministicRandomSeed=false disableDithering=false maxRuntime=-1 maxRuntimeUnits=MINUTES downsampling_type=BY_SAMPLE downsample_to_fraction=null downsample_to_coverage=1000 baq=OFF baqGapOpenPenalty=40.0 refactor_NDN_cigar_string=false fix_misencoded_quality_scores=false allow_potentially_misencoded_quality_scores=false useOriginalQualities=false defaultBaseQualities=-1 performanceLog=null BQSR=null quantize_quals=0 disable_indel_quals=false emit_original_quals=false preserve_qscores_less_than=6 globalQScorePrior=-1.0 validation_strictness=SILENT remove_program_records=false keep_program_records=false sample_rename_mapping_file=null unsafe=null disable_auto_index_creation_and_locking_when_reading_rods=false num_threads=1 num_cpu_threads_per_data_thread=1 num_io_threads=0 monitorThreadEfficiency=false num_bam_file_handles=null read_group_black_list=null pedigree=[] pedigreeString=[] pedigreeValidationType=STRICT allow_intervals_with_unindexed_bam=false generateShadowBCF=false variant_index_type=DYNAMIC_SEEK variant_index_parameter=-1 logging_level=INFO log_to_file=null help=false version=false variant=[(RodBindingCollection [(RodBinding name=variant source=/hpc/cog_bioinf/data/robert/testIAP/testSubsetExome/tmp/testSubsetExome.filtered_snps.vcf)]), (RodBindingCollection [(RodBinding name=variant2 source=/hpc/cog_bioinf/data/robert/testIAP/testSubsetExome/tmp/testSubsetExome.filtered_indels.vcf)])] out=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub no_cmdline_in_header=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub sites_only=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub bcf=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub genotypemergeoption=UNSORTED filteredrecordsmergetype=KEEP_IF_ANY_UNFILTERED multipleallelesmergetype=BY_TYPE rod_priority_list=null printComplexMerges=false filteredAreUncalled=false minimalVCF=false excludeNonVariants=false setKey=set assumeIdenticalSamples=false minimumN=1 suppressCommandLineHeader=false mergeInfoWithMaxAC=false filter_reads_with_N_cigar=false filter_mismatching_base_and_quals=false filter_bases_not_stored=false">
LINE1

h = {}
s = gatkcommandline.strip
# print s,"\n"
result = BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
# h[result['ID']] = result
# p result

lines = <<LINES
##FILTER=<ID=HaplotypeScoreHigh,Description="HaplotypeScore > 13.0">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth",Extra="Yes?">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
##INFO=<ID=VP,Number=1,Type=String,Description="Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf",Source="dbsnp",Version="138">
##INFO=<ID=GENEINFO,Number=1,Type=String,Description="Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)">
##INFO=<ID=CLNHGVS,Number=.,Type=String,Description="Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags.">
##INFO=<ID=CLNHGVS1,Number=.,Type=String,Description="Variant names from \\"HGVS\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags.">
##contig=<ID=XXXY12>
##contig=<ID=Y,length=59373566>
LINES

h = {}
lines.strip.split("\n").each { |s|
  # print s,"\n"
  result = BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
  h[result['ID']] = result
  p result
}
p h

raise "ERROR" if h != {"HaplotypeScoreHigh"=>{"ID"=>"HaplotypeScoreHigh", "Description"=>"HaplotypeScore > 13.0"}, "GT"=>{"ID"=>"GT", "Number"=>"1", "Type"=>"String", "Description"=>"Genotype"}, "DP"=>{"ID"=>"DP", "Number"=>"1", "Type"=>"Integer", "Description"=>"Total read depth", "Extra"=>"Yes?"}, "DP4"=>{"ID"=>"DP4", "Number"=>"4", "Type"=>"Integer", "Description"=>"# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases"}, "PM"=>{"ID"=>"PM", "Number"=>"0", "Type"=>"Flag", "Description"=>"Variant is Precious(Clinical,Pubmed Cited)"}, "VP"=>{"ID"=>"VP", "Number"=>"1", "Type"=>"String", "Description"=>"Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf", "Source"=>"dbsnp", "Version"=>"138"}, "GENEINFO"=>{"ID"=>"GENEINFO", "Number"=>"1", "Type"=>"String", "Description"=>"Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)"}, "CLNHGVS"=>{"ID"=>"CLNHGVS", "Number"=>".", "Type"=>"String", "Description"=>"Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags."}, "CLNHGVS1"=>{"ID"=>"CLNHGVS1", "Number"=>".", "Type"=>"String", "Description"=>"Variant names from \\\"HGVS\\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags."}, "XXXY12"=>{"ID"=>"XXXY12"}, "Y"=>{"ID"=>"Y", "length"=>59373566}}


end # test
