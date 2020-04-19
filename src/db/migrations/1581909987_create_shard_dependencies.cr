class CreateShardDependencies
  include Clear::Migration

  def change(dir)
    create_table(:shard_dependencies, id: false) do |t|
      t.references "shards", "parent_id", type: :uuid, null: false
      t.references "projects", "dependency_id", type: :uuid, null: false
      t.column :ref_type, :ref_type, index: true, null: false
      t.column :ref_name, :string, index: true, null: false
      t.column :requirement_operator, :dependency_requirement_operator, null: false
      t.column :requirement_version, :string, index: true
      t.column :development, type: :boolean, default: false, null: false

      t.timestamps

      t.index ["parent_id", "dependency_id"], unique: true
    end

    dir.up do
      execute <<-SQL
        ALTER TABLE shard_dependencies ADD CONSTRAINT shard_dependencies_pkey primary key (parent_id, dependency_id);
      SQL
    end

    dir.down do
      execute <<-SQL
        ALTER TABLE shard_dependencies DROP CONSTRAINT shard_dependencies_pkey;
      SQL
    end
  end
end
