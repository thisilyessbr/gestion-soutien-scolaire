package com.dao;

import com.model.Etudiant;

import java.sql.SQLException;
import java.util.List;

public interface IEtudiant {

    public List<Etudiant> getAllEtudiants() throws SQLException;
}
