# pop all images into array and then exact match which one(s) to keep
# made by Conor Gaffney, 2012

module Jekyll
  module RemoveImage
      def remove_images(input, keep = '')
          img_array = input.scan(/<img.*?>/)

          if img_array.empty? == true
            input
          else
          keep_last = img_array.count - keep.to_i
          img_array = img_array.last(keep_last)

          img_array.each do |x|
            input = input.gsub(/#{x}/, '')
          end
          input
        end
      end
    end
end

Liquid::Template.register_filter(Jekyll::RemoveImage)