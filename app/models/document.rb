class Document < ApplicationRecord
  has_and_belongs_to_many :biddings, foreign_key: :minute_document_id,
                                     association_foreign_key: :bidding_id,
                                     join_table: 'biddings_and_minute_documents'

  validates_presence_of :file

  enum document_type: [:'Autorização de Fornecimento', :'Ordem de Serviço', :'Contrato']

  mount_uploader :file, DocumentUploader::Pdf
end
