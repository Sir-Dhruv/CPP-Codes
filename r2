import React, { useState } from "react";
import {
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Paper,
} from "@mui/material";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";

// --- Mock Data ---
const initialBatches = [
  {
    id: "BATCH001",
    amount: 1200000,
    date: "2024-09-01",
    approvalsRequired: 3,
    approvers: [
      { id: "AP1", name: "Alice", status: "Approved", date: "2024-09-02" },
      { id: "AP2", name: "Bob", status: "Pending", date: null },
      { id: "AP3", name: "Charlie", status: "Pending", date: null },
    ],
    payments: [
      { id: "P1", payee: "Rahul", amount: 600000 },
      { id: "P2", payee: "Priya", amount: 600000 },
    ],
  },
  {
    id: "BATCH002",
    amount: 250000,
    date: "2024-09-05",
    approvalsRequired: 2,
    approvers: [
      { id: "AP1", name: "Alice", status: "Approved", date: "2024-09-06" },
      { id: "AP2", name: "Bob", status: "Approved", date: "2024-09-06" },
    ],
    payments: [
      { id: "P3", payee: "Amit", amount: 250000 },
    ],
  },
  {
    id: "BATCH003",
    amount: 80000,
    date: "2024-09-07",
    approvalsRequired: 1,
    approvers: [
      { id: "AP1", name: "Alice", status: "Pending", date: null },
    ],
    payments: [
      { id: "P4", payee: "Sneha", amount: 80000 },
    ],
  },
];

// --- Utils ---
const formatCurrency = (amt) => `₹${amt.toLocaleString()}`;
const getStatusColor = (status) => {
  if (status === "Approved") return "green";
  if (status === "Rejected") return "red";
  return "orange";
};

export default function PayrollApprovalSystem() {
  const [batches, setBatches] = useState(initialBatches);
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedBatch, setSelectedBatch] = useState(null);

  // --- Filtering ---
  const filteredBatches = batches.filter((batch) => {
    const term = searchTerm.toLowerCase();
    return (
      batch.id.toLowerCase().includes(term) ||
      batch.date.includes(term)
    );
  });

  // --- Handle Approvals ---
  const handleApprove = (batchId, approverId) => {
    setBatches((prev) =>
      prev.map((batch) =>
        batch.id === batchId
          ? {
              ...batch,
              approvers: batch.approvers.map((ap) =>
                ap.id === approverId
                  ? { ...ap, status: "Approved", date: new Date().toISOString().split("T")[0] }
                  : ap
              ),
            }
          : batch
      )
    );
    setSelectedBatch(null);
  };

  const handleReject = (batchId, approverId) => {
    setBatches((prev) =>
      prev.map((batch) =>
        batch.id === batchId
          ? {
              ...batch,
              approvers: batch.approvers.map((ap) =>
                ap.id === approverId
                  ? { ...ap, status: "Rejected", date: new Date().toISOString().split("T")[0] }
                  : ap
              ),
            }
          : batch
      )
    );
    setSelectedBatch(null);
  };

  return (
    <Paper sx={{ p: 3, maxWidth: 900, mx: "auto", mt: 5, bgcolor: "#f0f6ff" }}>
      <Typography variant="h4" gutterBottom sx={{ color: "primary.main" }}>
        Payroll Approval System
      </Typography>

      {/* Search */}
      <TextField
        label="Search by Batch ID or Date"
        fullWidth
        variant="outlined"
        margin="normal"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        sx={{ bgcolor: "white" }}
      />

      {filteredBatches.map((batch) => (
        <Accordion key={batch.id} sx={{ bgcolor: "white", mb: 2 }}>
          <AccordionSummary expandIcon={<ExpandMoreIcon sx={{ color: "primary.main" }} />}>
            <Typography variant="h6" sx={{ color: "primary.dark" }}>
              {batch.id} — {formatCurrency(batch.amount)} — {batch.date}
            </Typography>
          </AccordionSummary>
          <AccordionDetails>
            <Typography variant="subtitle1" sx={{ color: "primary.main" }}>Payments:</Typography>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Payee</TableCell>
                  <TableCell>Amount</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {batch.payments.map((p) => (
                  <TableRow key={p.id}>
                    <TableCell>{p.payee}</TableCell>
                    <TableCell>{formatCurrency(p.amount)}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>

            <Typography variant="subtitle1" sx={{ mt: 2, color: "primary.main" }}>
              Approvers:
            </Typography>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Name</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Date</TableCell>
                  <TableCell>Action</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {batch.approvers.map((ap) => (
                  <TableRow key={ap.id}>
                    <TableCell>{ap.name}</TableCell>
                    <TableCell sx={{ color: getStatusColor(ap.status) }}>{ap.status}</TableCell>
                    <TableCell>{ap.date || "-"}</TableCell>
                    <TableCell>
                      {ap.status === "Pending" && (
                        <>
                          <Button
                            variant="contained"
                            color="primary"
                            size="small"
                            sx={{ mr: 1 }}
                            onClick={() => setSelectedBatch({ batchId: batch.id, approverId: ap.id, action: "approve" })}
                          >
                            Approve
                          </Button>
                          <Button
                            variant="outlined"
                            color="primary"
                            size="small"
                            onClick={() => setSelectedBatch({ batchId: batch.id, approverId: ap.id, action: "reject" })}
                          >
                            Reject
                          </Button>
                        </>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </AccordionDetails>
        </Accordion>
      ))}

      {/* Approval Dialog */}
      <Dialog open={!!selectedBatch} onClose={() => setSelectedBatch(null)}>
        <DialogTitle sx={{ color: "primary.main" }}>Confirm Action</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to {selectedBatch?.action} this approval?
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setSelectedBatch(null)}>Cancel</Button>
          <Button
            onClick={() =>
              selectedBatch?.action === "approve"
                ? handleApprove(selectedBatch.batchId, selectedBatch.approverId)
                : handleReject(selectedBatch.batchId, selectedBatch.approverId)
            }
            variant="contained"
            color="primary"
          >
            Confirm
          </Button>
        </DialogActions>
      </Dialog>
    </Paper>
  );
}
