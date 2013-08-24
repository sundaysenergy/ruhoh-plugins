## my-website/plugins/pages_find_by_name.rb

def collate_by_sub_collection
  collated = Hash.new
  sub_collections = Hash.new
  pages = all
  pages.each_with_index do |page, i|
    if page.pointer['id'].scan('/').length > 0
      sub_collection = page.pointer['id'].split('/')
      sub_collection.pop
      
      if sub_collections[sub_collection.join('/').to_sym].nil?
        sub_collections[sub_collection.join('/').to_sym] = Array.new
      end
      sub_collections[sub_collection.join('/').to_sym] << page['id']
    else
      if sub_collections[:root].nil?
        sub_collections[:root] = Array.new
      end
      sub_collections[:root] << page['id']
    end
  end
  sub_collections.each do |collection,posts|
    collated[collection] = {
      'directory' => collection,
      resource_name => posts
    }
  end
  collated["all"] = collated.each_value.map { |sub_collection| sub_collection }
  collated
end

Ruhoh::Resources::Pages::CollectionView.send(:include, PagesFindByName)
