module Participa
  module Test
    module RegistrationHelpers
      def create_user_registration(user, document_vatid, email)
        visit new_user_registration_path
        fill_in_user_registration(user, document_vatid, email)
        click_button "Inscribirse"
      end

      def fill_in_user_registration(user, document_vatid, email)
        fill_in_personal_data(user, document_vatid)
        fill_in_location_data(province: 'Barcelona',
                              town: 'Barcelona',
                              postal_code: '08021')
        fill_in_login_data(user, email)
        acknowledge_stuff
      end

      def fill_in_location_data(country: nil,
                                province:,
                                town: nil,
                                postal_code: '08021')
        if country
          uncheck 'Resido en Cataluña'
          select(country, from: 'País')
        end

        select(province, from: 'Provincia')
        select(town, from: 'Municipio') if town
        fill_in('Código postal', with: postal_code)
        fill_in('Dirección', with: 'C/El Muro, S/N')
      end

      def acknowledge_stuff
        check('user_inscription')
        check('user_terms_of_service')
        # XXX: the cookie policy gets in the middle here, so check won't work.
        # Investigate and fix
        find('input[type=checkbox]#user_over_18').trigger('click')
      end

      def fill_in_login_data(user, email)
        fill_in('Correo electrónico*', :with => email)
        fill_in('Correo electrónico (repetir)*', :with => email)
        fill_in('Contraseña*', :with => user.password)
        fill_in('Contraseña (repetir)*', :with => user.password)
      end

      def fill_in_personal_data(user, document_vatid)
        fill_in('Nombre', :with => user.first_name)
        fill_in('Apellidos', :with => user.last_name)
        select("Pasaporte", from: "Tipo de documento")
        fill_in('DNI', :with => document_vatid)
        select("1970", from: "user[born_at(1i)]")
        select("enero", from: "user[born_at(2i)]")
        select("1", from: "user[born_at(3i)]")
      end
    end
  end
end
