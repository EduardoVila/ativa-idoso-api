class CreateBoaVistaTables < ActiveRecord::Migration[7.1]
  def change
    
    create_table :boa_vista_cadastrals, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :raw_data         
      t.references :consumer, polymorphic: true, type: :uuid, null: false, index: true 
      t.timestamps
    end
     
    create_table :boa_vista_cadastral_locations, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpf, null: false                                 
      t.string :emails, array: true   
      t.references :boa_vista_cadastral, type: :uuid, null: false, foreign_key: true, index: true 
      t.timestamps              
    end
    
    create_table :boa_vista_addresses, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :street_type                     
      t.string :street                         
      t.string :number                          
      t.string :neighborhood                   
      t.string :city                            
      t.string :federal_unit                    
      t.string :zip_code                          
      t.string :complement                      
      t.string :address_type     
      t.references :boa_vista_cadastral_location, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps        
    end
    
    create_table :boa_vista_basic_registrations, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpf                    
      t.string :name                   
      t.string :mother_name                                
      t.string :birth_date             
      t.string :exposed_person         
      t.string :cpf_situation 
      t.references :boa_vista_cadastral, type: :uuid, null: false, foreign_key: true, index: true  
      t.timestamps        
    end

    create_table :boa_vista_cadastral_qualifications, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpf, null: false                              
      t.string :death                              
      t.references :boa_vista_cadastral, type: :uuid, null: false, foreign_key: true, index: true 
      t.timestamps
    end

    create_table :boa_vista_phones, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :ddd                             
      t.string :number                          
      t.string :phone_type                                                    
      t.references :boa_vista_cadastral_location, type: :uuid, null: false, foreign_key: true, index: true 
      t.timestamps
    end

    create_table :boa_vista_related_people, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :name                                
      t.string :degree_of_kinship                                              
      t.string :cpf 
      t.references :boa_vista_cadastral_qualification, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end