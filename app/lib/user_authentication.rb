module UserAuthentication

    def authenticate_with_password!(password)
        # this isn't secure and passwords shouldn't be stored in plain text
        # it should at least be put through a one-way hash
        if password == self.password
            self.update(login_key: "#{self.class.name}::#{SecureRandom.base64(24)}")
            true
        else
            false
        end
    end

end