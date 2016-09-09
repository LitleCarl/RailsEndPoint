class RenameKeyInStickerConfig < ActiveRecord::Migration
  def change
    rename_column :sticker_configs, :key, :sticker_key
  end
end
