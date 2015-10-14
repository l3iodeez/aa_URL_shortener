class CreateTaggingsAndTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :topic_name

      t.timestamps
    end
    create_table :taggings do |t|
      t.integer :shortened_url_id
      t.integer :tag_topic_id

      t.timestamps
    end

    add_index :taggings, :shortened_url_id
    add_index :taggings, :tag_topic_id
  end
end
