
import numpy as np

def extract_monomer_list(u):
    all_monomers = []
    grp_PEG = u.select_atoms("resid 1")
    grp_PEG_O = u.select_atoms("type 4 6")
    for id_oxygen in grp_PEG_O.indices:
        # create a list
        monomer_atom_list = [id_oxygen]
        # detect the location of the carbon bonded to the oxygen
        where_is_CO_bond = np.where(np.sum(grp_PEG.bonds.indices == id_oxygen, axis=1))[0]
        for CO_bond in where_is_CO_bond:
            id_carbon = grp_PEG.bonds.indices[CO_bond].tolist()
            id_carbon.remove(id_oxygen)
            # add carbon in the monomer_atom_list
            monomer_atom_list.append(id_carbon[0])
            # detect the location of the hydrogen bonded to the carbon
            where_is_CH_bond = np.where(np.sum(grp_PEG.bonds.indices == id_carbon, axis=1))[0]
            for CH_bond in where_is_CH_bond:
                id_hydrogen = grp_PEG.bonds.indices[CH_bond].tolist()
                id_hydrogen.remove(id_carbon[0])
                atom_type = u.select_atoms("index "+str(id_hydrogen[0])).atoms.types
                if (atom_type == "5") | (atom_type == "7"):
                    # add hydrogen in the monomer_atom_list
                    monomer_atom_list.append(id_hydrogen[0])
        monomer_atom_list = np.unique(monomer_atom_list)
        monomer = u.select_atoms('index '+ ' '.join(str(e) for e in monomer_atom_list))
        assert (monomer.atoms.n_atoms == 5) | (monomer.atoms.n_atoms == 7), "wrong number of atom in monomer"
        assert monomer.select_atoms("type 4 6").atoms.n_atoms == 1, "should be one oxygen"
        assert len(np.unique(monomer.atoms.resids)) == 1, "monomer not from the same residue"
        all_monomers.append(monomer)
    return all_monomers
