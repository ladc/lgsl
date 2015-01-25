local function lgsl_loader(name)
    if string.sub(name, 1, 4) == 'lgsl' then
        if name == 'lgsl' then
            return loadfile("src/init.lua")
        else
            local subname = string.match(name, "^lgsl%.([^.]*)")
            if subname then
                return loadfile("src/" .. subname .. ".lua")
            end
        end
    end
end

table.insert(package.loaders, 2, lgsl_loader)

