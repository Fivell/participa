module Participa
  module Test
    module RegistrationHelpers
      def create_user_registration(user, document_vatid, email)
        visit new_user_registration_path
        fill_in('Nombre', :with => user.first_name)
        fill_in('Apellidos', :with => user.last_name)
        select("Pasaporte", from: "Tipo de documento")
        fill_in('DNI', :with => document_vatid)
        select('Barcelona', :from=>'Provincia')
        select("Barcelona", from: "Municipio")
        select("1970", from: "user[born_at(1i)]")
        select("enero", from: "user[born_at(2i)]")
        select("1", from: "user[born_at(3i)]")
        fill_in('Código postal', :with => '08021')
        fill_in('Dirección', :with => 'C/El Muro, S/N')
        fill_in('Correo electrónico*', :with => email)
        fill_in('Correo electrónico (repetir)*', :with => email)
        fill_in('Contraseña*', :with => user.password)
        fill_in('Contraseña (repetir)*', :with => user.password)
        check('user_inscription')
        check('user_terms_of_service')
        # XXX: the cookie policy gets in the middle here, so check won't work.
        # Investigate and fix
        find('input[type=checkbox]#user_over_18').trigger('click')
        click_button "Inscribirse"
      end
    end
  end
end
