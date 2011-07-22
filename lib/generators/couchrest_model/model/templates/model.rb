class <%= class_name %><%= options[:parent] != nil ? " < #{options[:parent].classify}" : " < CouchRest::Model::Base" %>

  #use_database '<%= class_name.underscore %>'

<% model_attributes.each_with_index do |attribute, i| -%>
  property :<%= attribute.name %><%= ", :type => #{attribute.type_class}" %>
<% end -%>

<%= statements %>

end
