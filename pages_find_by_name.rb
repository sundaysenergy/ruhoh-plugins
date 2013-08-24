## my-website/plugins/pages_find_by_name.rb

module PagesFindByName
  def find_by_name
    @find_by_name ||= FindByNameProxy.new(self)
  end

  class FindByNameProxy < SimpleDelegator
    def method_missing(name, *args, &block)
      model = __getobj__.find(name.to_s)
      model ? model : super
    end

    def respond_to?(method)
      __getobj__.find(method.to_s) ? true : super
    end
  end
end

Ruhoh::Resources::Pages::CollectionView.send(:include, PagesFindByName)
