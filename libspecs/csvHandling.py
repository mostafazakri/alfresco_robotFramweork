""" def return_list_from_csv(filename):
    f = open(filename,"r")
    if f.mode == 'r': 
        fl = f.readlines() 
        for x in fl:
            print (x)
    f.close() 
if __name__ == "__main__":
    main()
"""     

def return_list_from_csv(file_name):
    # Ouverture du fichier en lecture mode binaire
    data_pool_file = open(file_name, "r")
    data_list = data_pool_file.readlines()
    data_pool_file.close()
    return data_list
