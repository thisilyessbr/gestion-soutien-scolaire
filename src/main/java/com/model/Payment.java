package com.model;

import java.math.BigDecimal;
import java.util.Date;

public class Payment {

    private int paymentId;
    private int userId;
    private BigDecimal paymentAmount;
    private String paymentMethod;
    private Date paymentDate;
    private BigDecimal montantPaye;
    private BigDecimal montantReste;
    private String etat , nom_etudiant , prenom_etudiant ;


    // Constructors, getters, setters, and other methods

    public Payment() {
        // Default constructor
    }

    public Payment(int userId, BigDecimal paymentAmount, String paymentMethod, Date paymentDate,
                   BigDecimal montantPaye, BigDecimal montantReste, String etat) {
        this.userId = userId;
        this.paymentAmount = paymentAmount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.montantPaye = montantPaye;
        this.montantReste = montantReste;
        this.etat = etat;
    }
    public Payment(BigDecimal paymentAmount, String paymentMethod, Date paymentDate,
                   BigDecimal montantPaye, BigDecimal montantReste, String etat) {
        this.paymentAmount = paymentAmount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.montantPaye = montantPaye;
        this.montantReste = montantReste;
        this.etat = etat;
    }

    public String getPrenom_etudiant() {
        return prenom_etudiant;
    }

    public void setPrenom_etudiant(String prenom_etudiant) {
        this.prenom_etudiant = prenom_etudiant;
    }

    public String getNom_etudiant() {
        return nom_etudiant;
    }

    public void setNom_etudiant(String nom_etudiant) {
        this.nom_etudiant = nom_etudiant;
    }

    // Getters and Setters for all fields

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getMontantPaye() {
        return montantPaye;
    }

    public void setMontantPaye(BigDecimal montantPaye) {
        this.montantPaye = montantPaye;
    }

    public BigDecimal getMontantReste() {
        return montantReste;
    }

    public void setMontantReste(BigDecimal montantReste) {
        this.montantReste = montantReste;
    }

    public String getEtat() {
        return etat;
    }

    public void setEtat(String etat) {
        this.etat = etat;
    }
}
