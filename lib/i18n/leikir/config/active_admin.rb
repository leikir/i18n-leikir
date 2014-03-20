ActiveAdmin.register Translation do
  menu label: "Texts"

  actions :index, :edit, :update, :show

  index do
    column :locale
    column :key
    column :value
    default_actions
  end

  show do |t|
    attributes_table do
      row :locale
      row :key
      row :value do
        raw t.value
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :locale
      f.input :key
      f.input :value, as: :html_editor
    end

    #f.buttons seems deprecated
    f.actions
  end

  controller do
    def permitted_params
      params.permit(:translation => [:locale, :key, :value, :interpolations, :is_proc])
    end
  end

end
