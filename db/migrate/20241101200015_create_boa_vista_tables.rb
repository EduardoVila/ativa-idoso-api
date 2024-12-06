class CreateBoaVistaTables < ActiveRecord::Migration[7.1]
  def change
    create_table :boa_vista_cadastrals do |t|
      t.string :raw_data         
      t.references :consumer, polymorphic: true, type: :uuid, null: true, index: true 
      t.timestamps
    end

    create_table :boa_vista_cadastral_locations do |t|
      t.string :cpf, null: false
      t.string :emails, array: true
      t.references :boa_vista_cadastral, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :boa_vista_addresses  do |t|
      t.string :street_type
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :federal_unit
      t.string :zip_code
      t.string :complement
      t.string :address_type
      t.references :boa_vista_cadastral_location, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :boa_vista_basic_registrations do |t|
      t.string :cpf
      t.string :name
      t.string :mother_name
      t.string :birth_date
      t.string :exposed_person
      t.string :cpf_situation
      t.references :boa_vista_cadastral, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :boa_vista_cadastral_qualifications do |t|
      t.string :cpf, null: false
      t.string :death
      t.references :boa_vista_cadastral, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :boa_vista_phones do |t|
      t.string :ddd
      t.string :number
      t.string :phone_type
      t.references :boa_vista_cadastral_location, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :boa_vista_related_people do |t|
      t.string :name
      t.string :degree_of_kinship
      t.string :cpf
      t.references :boa_vista_cadastral_qualification, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
