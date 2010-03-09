LABELINGS.each_pair do |filter, labels|
    if filter.matches(message)
        labels.each do |label|
            message.add_label label
        end
    end
end

ARCHIVE.each do |filter|
    if filter.matches(message)
        message.remove_label :inbox
    end
end
