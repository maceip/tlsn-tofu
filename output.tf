# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "verifier_address" {
  value = azurerm_linux_virtual_machine.main.id
}

output "prover_address" {
  value = azurerm_linux_virtual_machine.prover.id
}