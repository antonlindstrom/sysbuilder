# SysBuilder

This is a project for building images in KVM from an image.

This project is in an early stage and the goal is to automate the whole process
of setting up a new machine from a template.

## Usage

    sudo ./create_vm mymachine.example.com /path/to/template.qcow

Optional:

    sudo ./create_vm mymachine.example.com /path/to/template.qcow /path/to/vm/storage

To remove a VM, use the following command:

    sudo ./destroy_vm mymachine.example.com

## Details

The `create_vm` script runs both `scripts/sysprep.sh` and `scripts/build_template.sh` as
well as defining and starting the VM with `virsh`.

Default settings per template:

* 512MB Memory
* 1 vCPU

For templates, see https://github.com/antonlindstrom/sysbuilder-template

### Environment

It should be fairly simple to change the path of the image location but default
is that they are stored at `/var/lib/libvirt/images`.

### Requirements

These Ubuntu packages are required:

* guestmount
* libguest-tools
* uuid

This should work:

    apt-get install guestmount libguestfs-tools uuid

### Whishlist

Next steps on wishlist:
* Flavors in `create_vm`, like small, medium, large (like tshirts omg!)
* An API to copy and create machines via HTTP from template
