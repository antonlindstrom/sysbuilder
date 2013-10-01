# SysBuilder

This is a project for building images in KVM from a defined template made by
Packer.

This project is in an early stage and the goal is to automate the whole process
of setting up a new machine from a template.

## Usage

    sudo ./create_vm.sh mymachine.example.com

## Details

Due to the lack of KVM support in Packer, we're building the image in
Virtualbox. Export it to qcow and run `sysprep.sh`.

1. Run `packer build packer.json` (cd into `packer/`)
2. Extract the `.ova` (`tar -tf ubuntu1204.ova`)
2. Convert the vmdk-file; `qemu-img convert -O qcow ubuntu1204-disk1.vmdk ubuntu1204.qcow`
3. Run `./sysprep.sh HOSTNAME`, output will be hostname.qcow
4. Set correct variables in `kvm/build_template.sh`
5. Run `build_template.sh HOSTNAME` to get an XML definition.
6. Run `virsh define $YOUR_NEW_DEFINITION`
7. Run `virsh start $VM_HOSTNAME`

The `create_vm.sh` script runs both `sysprep.sh` and `build_template.sh` as
well as defining and starting the VM with `virsh`.

### Environment

It should be fairly simple to change the path of the image location but default
is that they are stored at `/mnt/storage/vms`.

### Requirements

These Ubuntu packages are required:

* guestmount
* libguest-tools
* uuid

This should work:

    apt-get install guestmount libguest-tools uuid

### Whishlist

Next steps on wishlist:
* Flavors in `create_vm.sh`, like small, medium, large (like tshirts omg!)
* An API to copy and create machines via HTTP from template

### Wat?

Why the #$%"! is this built with bash scripts? These scripts are made to leave
as small footprint as possible on the server that's running this. You shouldn't
have to install a new language or find dependencies.

It's meant to be simple, because everyone loves simplicity.
