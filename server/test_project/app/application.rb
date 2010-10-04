# encoding: utf-8
#
class BookSearch < Application
  
  indexes do
    # defaults :partial => Cacher::Partial::Subtoken.new, :similarity => Cacher::Similarity::None.new
    
    illegal_characters(/[',\(\)#:!@;\?]/)
    contract_expressions(/mr\.\s*|mister\s*/i, 'mr ')
    stopwords(/\b(and|the|or|on|of|in|is|to|from|as|at|an)\b/)
    split_text_on(/[\s\/\-\"\&\.]/)
    illegal_characters_after_splitting(/[\.]/)
    
    few_similarities = Similarity::DoubleLevenshtone.new(3)
    similar_title = field :title,  :similarity => few_similarities,
                                   :qualifiers => [:t, :title, :titre]
    author        = field :author, :qualifiers => [:a, :author, :auteur]
    year          = field :year,   :partial    => Partial::None.new,
                                   :qualifiers => [:y, :year, :annee]
    isbn          = field :isbn,   :qualifiers => [:i, :isbn]
    
    type :main,
          Sources::DB.new('SELECT id, title, author, year FROM books', :file => 'app/db.yml'),
          similar_title,
          author,
          year
    
    type :isbn,
          Sources::DB.new("SELECT id, isbn FROM books", :file => 'app/db.yml'),
          field(:isbn, :qualifiers => [:i, :isbn])
    
    type :csv_test,
          Sources::CSV.new(:title,:author,:isbn,:year,:publisher,:subjects, :file => 'data/books.csv'),
          similar_title,
          author,
          isbn,
          year,
          field(:publisher, :qualifiers => [:p, :publisher]),
          field(:subjects, :qualifiers => [:s, :subject])
  end
  
  queries do
    # TODO Should these be definable per Query?
    #      And serve only as defaults if the query cannot find them?
    #
    maximum_tokens 5
    illegal_characters(/[\(\)\']/)
    contract_expressions(/mr\.\s*|mister\s*/i, 'mr')
    stopwords(/\b(and|the|or|on)/i)
    split_text_on(/[\s\/\-\,\&]+/) #
    normalize_words([
      [/Deoxyribonucleic Acid/i, 'DNA']
    ])
    illegal_characters_after_splitting(/[\.]/)
    
    options = { :weights => Query::Weights.new([:author] => 6, [:title, :author] => 5, [:author, :year] => 2) }
    
    route %r{^/books/full}, Query::Full.new(Indexes[:main], Indexes[:isbn], options)
    route %r{^/books/live}, Query::Live.new(Indexes[:main], Indexes[:isbn], options)
    
    route %r{^/isbn/full},  Query::Full.new(Indexes[:isbn], options)
    
    root 200
  end
  
end